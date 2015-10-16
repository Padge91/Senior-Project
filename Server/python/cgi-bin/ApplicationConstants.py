__author__ = 'Ryan'

messages = dict()

messages["ItemNotFound"] = "Item Not Found"
messages["ScoreOutOfBounds"] = "Score must be between 0 and "
messages["ParentTypeMismatch"] = "parent_type must be either 'comment' or 'item'"
messages["ParnetTypeNotFound"] = "Parent object not found"
messages["CommentSavingError"] = "Error saving comment."
messages["RatingFieldError"] = "Rating field must be either 'true' or 'false'"
messages["CommentNotFound"] = "Comment not found"
messages["LibraryNotFound"] = "Library not found"
messages["LibraryAccessError"] = "You do not have access to modify this library"
messages["ExistingLibraryName"] = "You already have an existing library with that name"
messages["ItemInLibrary"] = "Item already in library"
messages["NoSession"] = "No session found"
messages["PasswordMismatch"] = "Password does not match"
messages["MultipleLogoffs"] = "Already logged out."
messages["AccountNotFound"] = "Account not found"
messages["AccountSaveError"] = "Error saving account."
messages["UsernameExists"] = "Username already exists."
messages["EmailExists"] = "Email already exists."
messages["PasswordConfirmMismatch"] = "Passwords are not the same"
messages["PasswordTooShort"] = "Password must be at least 8 characters long"
messages["PasswordCharacterMismatch"] = "Password must contain one capital letter, one special character, and one number"

configs = dict()

configs["maxscore"] = 5
configs["date"] = "%Y-%m-%d %H:%M:%S"
configs["libraries"] = ["Viewed", "Owned", "Wishlist"]
configs["passwordnumbers"] = "0123456789"
configs["passowrdcharacters"] = "ABCDEFGHIJKLMNOPQRSTUVQXYZ"
configs["passwordspecials"] = "!@#$%&?"
