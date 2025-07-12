MAIN.PY


from fastapi import FastAPI
from post_routes import router as post_router
from get_routes import router as get_router

app = FastAPI()

app.include_router(post_router)
app.include_router(get_router)

GET-ROUTES.PY

from fastapi import APIRouter, HTTPException
from database import connect_db, ensure_table_exists
from pytz import timezone, utc

router = APIRouter()

@router.get("/data/all")
def get_all_device_data():
    conn = connect_db()
    cur = conn.cursor()

    try:
        cur.execute("""
            SELECT table_name FROM information_schema.tables
            WHERE table_schema='public' AND table_name LIKE '%_data'
        """)
        tables = cur.fetchall()

        print("Tables detected:", [t[0] for t in tables])  # Debugging

        all_data = {}

        for table in tables:
            table_name = table[0]
            print(f"Fetching data from: {table_name}")  # Debugging

            cur.execute(f"SELECT * FROM {table_name}")
            rows = cur.fetchall()
            print(f"Rows fetched from {table_name}: {len(rows)}")  # Debugging

            if rows:
                columns = [desc[0] for desc in cur.description]
                table_data = [dict(zip(columns, row)) for row in rows]
                all_data[table_name] = table_data
            else:
                print(f"No data found in {table_name}")  # Debugging
                all_data[table_name] = []  # Ensure empty tables are included

        print(f"Final API response: {all_data}")  # Debugging
        return {"data": all_data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching data: {str(e)}")
    finally:
        cur.close()
        conn.close()

POST_ROUTES.PY


from fastapi import APIRouter, HTTPException, Body
from database import connect_db, ensure_table_exists

router = APIRouter()

@router.post("/data")
async def add_data_generic(data: dict = Body(...)):
    device_name = data.get("name")
    temperature = data.get("temperature")
    humidity = data.get("humidity")

    if not device_name:
        raise HTTPException(status_code=400, detail="Field 'name' is required")

    ensure_table_exists(device_name)

    conn = connect_db()
    cur = conn.cursor()
    table_name = f"{device_name}_data".lower()

    try:
        cur.execute(
            f"INSERT INTO {table_name} (temperature, humidity, timestamp) VALUES (%s, %s, NOW() AT TIME ZONE 'UTC')",
            (temperature, humidity)
        )
        conn.commit()

        return {
            "status": "success",
            "stored_in": table_name,
            "data": {
                "name": device_name,
                "temperature": float(temperature),
                "humidity": float(humidity)
            }
        }
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to add data: {str(e)}")
    finally:
        cur.close()
        conn.close()