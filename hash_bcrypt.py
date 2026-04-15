import bcrypt

# 1. The original password from the user
user_password = "my_super_secret_password_123"

# 2. Generate a 'Salt' and Hash the password
# The 'rounds' parameter determines the complexity (12 is standard)
salt = bcrypt.gensalt(rounds=12)
hashed_password = bcrypt.hashpw(user_password.encode('utf-8'), salt)

print(f"Stored Hash: {hashed_password.decode('utf-8')}")

# --- LOGIN SIMULATION ---

# 3. Verifying a password during login
attempt_correct = "my_super_secret_password_123"
attempt_wrong = "wrong_password"

# bcrypt.checkpw handles extracting the salt from the hash automatically
is_valid = bcrypt.checkpw(attempt_correct.encode('utf-8'), hashed_password)
is_invalid = bcrypt.checkpw(attempt_wrong.encode('utf-8'), hashed_password)

print(f"Login success: {is_valid}")   # Returns True
print(f"Login failure: {is_invalid}") # Returns False