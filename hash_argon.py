from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError

# Initialize the hasher
# Default parameters are usually sufficient, but can be customized
ph = PasswordHasher()

# 1. Registration: Hashing a password
user_password = "Eslam@2003"
hashed_value = ph.hash(user_password)

# This 'hashed_value' contains the salt, the version, and the 
# configuration parameters, all in one string for your database.
print(f"Hash to store: {hashed_value}")

# 2. Authentication: Verifying a password
def login(input_attempt, stored_hash):
    try:
        # Argon2 automatically extracts the salt and params from the hash
        ph.verify(stored_hash, input_attempt)
        print("Login successful!")
        
        # Check if the hash needs re-hashing (e.g., if you updated security parameters)
        if ph.check_needs_rehash(stored_hash):
            print("Notice: Password should be re-hashed with updated parameters.")
            
    except VerifyMismatchError:
        print("Login failed: Invalid password.")

# Testing the login
login("Eslam@2003", hashed_value)
login("wrong_password_123", hashed_value)