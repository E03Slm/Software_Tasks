import bcrypt
import pyodbc

def get_db_connection():
    """
    Handles the SQL Server connection logic.
    Returns a connection object or None if it fails.
    """
    conn_str = (
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=(localdb)\\MSSQLLocalDB;"
        "DATABASE=SmartInfusionPump;"
        "UID=engslm;"
        "PWD=;"
        "Trusted_Connection=yes;"
    )
    try:
        conn = pyodbc.connect(conn_str)
        return True, conn
    except pyodbc.Error as e:
        print(f"Connection Error Trace: {e}")
        return False, None


def verify_user_login(conn, username, provided_password):
    """
    Uses an active connection to check the password hash.
    Returns: bool (True if matched, False if user not found or mismatch)
    """
    try:
        cursor = conn.cursor()
        query = "SELECT [passwordHash] FROM [SmartInfusionPump].[dbo].[User] WHERE [username] = ?"
        cursor.execute(query, (username,))
        row = cursor.fetchone()

        if row:
            stored_hash = row[0]
            if isinstance(stored_hash, str):
                stored_hash = stored_hash.encode('utf-8')
            
            # Check password
            return bcrypt.checkpw(provided_password.encode('utf-8'), stored_hash)
        
        return False # User not found
    except Exception as e:
        print(f"Query Error: {e}")
        return False
    
def login_controller(username, password):
    """
    Identifies if the problem is Connection-related or Password-related.
    """
    # Step 1: Check Connection
    is_connected, conn = get_db_connection()
    
    if not is_connected:
        return "ERROR: Database Connection Failed"

    # Step 2: Check Password (since we know connection is now True)
    try:
        is_password_correct = verify_user_login(conn, username, password)
        
        if is_password_correct:
            return "SUCCESS: Login Authorized"
        else:
            return "FAILURE: Invalid Username or Password"
            
    finally:
        # Step 3: Always close the connection
        if conn:
            conn.close()





# --- HOW TO USE ---
if __name__ == "__main__":
    user_input = "nurse.carlos.martinez"
    pass_input = "p@ssw0rd"  # The password the user types in the UI
# --- Calling the Controller ---
    result =  login_controller(user_input, pass_input)
    print(result)
