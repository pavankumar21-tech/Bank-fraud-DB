import pymysql
import random
from datetime import datetime, timedelta

# ===================== CHANGE THESE =====================
DB_HOST     = "localhost"
DB_USER     = "root"               # usually root
DB_PASSWORD = "pawan21@" # nee MySQL password
DB_NAME     = "bankfrauddb"           # screenshot lo nee db name idi, correct ga change cheyyi
# ========================================================

conn = pymysql.connect(
    host=DB_HOST,
    user=DB_USER,
    password=DB_PASSWORD,
    database=DB_NAME
)
cur = conn.cursor()

# 1. Insert 30 customers
print("Inserting customers...")
for i in range(30):
    name = f"Customer_{i+1}"
    age = random.randint(20, 60)
    city = random.choice(["Guntur", "Vijayawada", "Hyderabad", "Vizag", "Tirupati", "Kurnool"])
    cur.execute("""
        INSERT INTO customers (name, age, city)
        VALUES (%s, %s, %s)
    """, (name, age, city))
    customer_id = cur.lastrowid

    # One account per customer
    acc_num = f"ACC{random.randint(10000000, 99999999)}"
    balance = round(random.uniform(10000, 200000), 2)
    cur.execute("""
        INSERT INTO accounts (customer_id, account_number, balance, account_type)
        VALUES (%s, %s, %s, 'savings')
    """, (customer_id, acc_num, balance))

conn.commit()
print("✅ 30 customers + 30 accounts inserted!")

# 2. Insert 6000–8000 transactions (with \~10% suspicious patterns)
print("Inserting transactions...")
for _ in range(7000):
    account_id = random.randint(1, 30)  # assuming account_ids 1 to 30
    amount_base = random.uniform(100, 10000)
    
    # Make \~10% look suspicious (high amount, night time, etc.)
    if random.random() < 0.10:
        amount_base *= random.uniform(4, 15)  # sudden high amount
    
    amount = round(amount_base, 2)
    
    tx_type = random.choice(['UPI', 'CARD', 'NETBANKING', 'ATM'])
    merchant = random.choice(['Amazon', 'Flipkart', 'Swiggy', 'PhonePe', 'Local Shop', 'IRCTC', 'Unknown'])
    
    # Random time in last 2 months, some at night
    days_back = random.randint(0, 60)
    hour = random.randint(0, 23)
    if random.random() < 0.18:  # \~18% chance night tx
        hour = random.randint(0, 5)
    
    tx_time = datetime.now() - timedelta(days=days_back, hours=random.randint(0, 23))
    tx_time = tx_time.replace(hour=hour, minute=random.randint(0, 59))

    cur.execute("""
        INSERT INTO transactions (account_id, amount, transaction_type, merchant, transaction_time)
        VALUES (%s, %s, %s, %s, %s)
    """, (account_id, amount, tx_type, merchant, tx_time))

conn.commit()
print("✅ 7000 transactions inserted! Some are suspicious patterns.")

cur.close()
conn.close()
print("All done! Now ready for fraud trigger.")