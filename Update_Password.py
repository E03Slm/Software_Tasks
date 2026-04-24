import bcrypt
import pyodbc

def update_user_password(username, new_plain_password):
    # 1. Connection String
    conn_str = (
        r"DRIVER={ODBC Driver 17 for SQL Server};"
        r"SERVER=(localdb)\MSSQLLocalDB;"
        r"DATABASE=SmartInfusionPump;"
        r"Trusted_Connection=yes;"
    )

    # 2. Generate a valid Bcrypt hash
    # This creates a string starting with $2b$ which is a valid salt format
    new_hash = bcrypt.hashpw(new_plain_password.encode('utf-8'), bcrypt.gensalt())

    conn = None
    try:
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()

        # 3. Update the passwordHash column
        # We use [User] in brackets because it is a reserved SQL keyword
        sql = "UPDATE [SmartInfusionPump].[dbo].[User] SET [passwordHash] = ? WHERE [username] = ?"
        
        # We decode the hash to a string to store it in a VARCHAR column
        cursor.execute(sql, (new_hash.decode('utf-8'), username))
        
        conn.commit()
        
        if cursor.rowcount > 0:
            print(f"Success: Password for '{username}' has been updated.")
        else:
            print(f"Error: User '{username}' not found.")

    except pyodbc.Error as e:
        print(f"Database error: {e}")
    finally:
        if conn:
            conn.close()

# --- RUN THIS TO FIX YOUR TABLE ---
#update_user_password("nurse.carlos.martinez", "p@ssw0rd") 
# Use this to set a known password for all users (for testing)
new_plain_password = "p@ssw0rd"
new_hash = bcrypt.hashpw(new_plain_password.encode('utf-8'), bcrypt.gensalt())
print(new_hash)
