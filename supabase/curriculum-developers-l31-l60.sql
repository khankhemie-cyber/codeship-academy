-- CODEship Academy — Developers Level Lessons 31–60 (Python Fundamentals)
INSERT INTO public.lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES

('dev-l31', 'Why Python? Your Second Language', 'developers', 'Python', 'en', 'intermediate', 35, 150, 31,
'## Why Python? Your Second Language

You already know JavaScript — so why learn another language? Because Python is one of the most powerful, readable, and widely-used languages on the planet. Scientists, engineers, game developers, and AI researchers all use Python every day.

### Python vs JavaScript: A Quick Comparison

| Feature | JavaScript | Python |
|---------|-----------|--------|
| Runs in | Browser + Node.js | Computer (terminal) |
| Syntax style | Curly braces `{}` | Indentation |
| Main uses | Web apps, front end | Data, AI, automation, scripts |
| Typing | Dynamic | Dynamic |
| Famous for | Making websites interactive | Making data useful |

Both languages are excellent. Knowing both makes you twice as powerful as a developer.

### What Can You Build with Python?

- **Data analysis** — crunch thousands of numbers in seconds
- **Automation** — rename 1000 files, send emails, scrape websites
- **Games** — 2D games with Pygame
- **Artificial Intelligence** — machine learning, chatbots, image recognition
- **Web back ends** — servers with Django or Flask
- **Science** — NASA, CERN, and weather forecasters all use Python

### Your First Python Program

```python
# This is a comment in Python (uses # not //)
print("Hello, World!")
print("I am learning Python!")
```

Run this in your terminal with `python hello.py` and you will see:

```
Hello, World!
I am learning Python!
```

### Python Feels Like Plain English

Compare the same task in both languages:

```javascript
// JavaScript
const numbers = [1, 2, 3, 4, 5];
const evens = numbers.filter(n => n % 2 === 0);
console.log(evens);
```

```python
# Python
numbers = [1, 2, 3, 4, 5]
evens = [n for n in numbers if n % 2 == 0]
print(evens)
```

Python uses indentation (spaces) instead of `{}` curly braces to group code. This forces you to write neat, readable code.

### Installing Python

Python comes pre-installed on most computers. Check by opening a terminal and typing:

```
python --version
```

or

```
python3 --version
```

You should see something like `Python 3.11.0`. If not, download it free from python.org.

### Running Python

Two ways to run Python code:

**Interactive mode** (great for experimenting):
```
python3
>>> print("Hello!")
Hello!
>>> 2 + 2
4
```

**Script mode** (write a file, run it):
```python
# save as my_script.py
name = "Alex"
print(f"Hello, {name}!")
```
Then run: `python3 my_script.py`

### Activity: Your First Python Script

1. Open a text editor and create `hello.py`
2. Write these lines:

```python
print("Hello from Python!")
print("My name is Python and I am awesome.")
print(2024 - 1991, "years since Python was created")
print("Pi is approximately", 3.14159)
```

3. Run it with `python3 hello.py`
4. Change the messages and run it again!

### Key Takeaways

- Python is a second language that opens doors to data, AI, and automation
- Python uses indentation instead of curly braces
- `print()` in Python does what `console.log()` does in JavaScript
- You can run Python interactively or as a saved script'),

('dev-l32', 'Python Variables and Data Types', 'developers', 'Python', 'en', 'intermediate', 35, 150, 32,
'## Python Variables and Data Types

Variables in Python work just like in JavaScript — they are containers that hold data. But Python has some interesting differences worth knowing.

### Creating Variables

In Python you do NOT need `const`, `let`, or `var`. Just write the name, an equals sign, and the value:

```python
name = "Jordan"
age = 13
height = 1.65
is_student = True
nothing = None
```

Python figures out the type automatically. This is called **dynamic typing**.

### The Five Core Data Types

#### 1. Integer (`int`) — whole numbers

```python
score = 100
temperature = -5
population = 8000000000

print(score)        # 100
print(type(score))  # <class ''int''>
```

#### 2. Float — decimal numbers

```python
price = 9.99
pi = 3.14159
battery = 0.87

print(price)        # 9.99
print(type(price))  # <class ''float''>
```

#### 3. String (`str`) — text

```python
first_name = "Alice"
last_name = ''Smith''
full_name = first_name + " " + last_name  # "Alice Smith"

print(full_name)         # Alice Smith
print(type(full_name))   # <class ''str''>
print(len(full_name))    # 11 (counts spaces too)
```

#### 4. Boolean (`bool`) — True or False

```python
is_raining = False
has_passed = True

print(is_raining)       # False
print(type(is_raining)) # <class ''bool''>

# Note: Python uses True/False with capital letters
# JavaScript uses true/false (lowercase)
```

#### 5. NoneType — the absence of a value

```python
result = None
print(result)        # None
print(type(result))  # <class ''NoneType''>

# None in Python = null in JavaScript
```

### The `type()` Function

Use `type()` to check what kind of data a variable holds:

```python
x = 42
y = 3.14
z = "hello"
w = True
v = None

print(type(x))  # <class ''int''>
print(type(y))  # <class ''float''>
print(type(z))  # <class ''str''>
print(type(w))  # <class ''bool''>
print(type(v))  # <class ''NoneType''>
```

### Converting Between Types

Python will not automatically mix types. You must convert explicitly:

```python
age_string = "13"
age_number = int(age_string)   # convert string to int
print(age_number + 1)          # 14

price = 9.99
price_int = int(price)         # 9 (decimal part dropped!)
price_str = str(price)         # "9.99"

is_active = bool(1)            # True
is_zero = bool(0)              # False
```

### Multiple Assignment

Python lets you assign several variables at once:

```python
x, y, z = 1, 2, 3
print(x, y, z)   # 1 2 3

a = b = c = 0    # all three equal 0
print(a, b, c)   # 0 0 0

# Swap values without a temp variable (Python trick!)
a, b = 10, 20
a, b = b, a
print(a, b)      # 20 10
```

### Variable Naming Rules

```python
# Good names (use snake_case in Python)
player_name = "Sam"
high_score = 9999
is_game_over = False
total_items = 5

# Bad names — these cause errors
# 2player = "Sam"    # cannot start with number
# my-name = "Sam"    # hyphens not allowed
# class = "maths"    # "class" is a reserved word
```

### Activity: About Me Variables

```python
# Create these variables about yourself
name = "Your Name"
age = 13
favourite_subject = "Coding"
height_cm = 160
is_morning_person = False

# Print them all
print("Name:", name)
print("Age:", age)
print("Favourite subject:", favourite_subject)
print("Height:", height_cm, "cm")
print("Morning person?", is_morning_person)

# Check types
print("Type of age:", type(age))
print("Type of height:", type(height_cm))
```

### Key Takeaways

- No `const`/`let` in Python — just write `name = value`
- The five main types: `int`, `float`, `str`, `bool`, `None`
- Use `type()` to inspect a variable''s type
- Convert between types with `int()`, `float()`, `str()`, `bool()`
- Python variable names use `snake_case` (underscores, not camelCase)'),

('dev-l33', 'Python Input and Print', 'developers', 'Python', 'en', 'intermediate', 35, 150, 33,
'## Python Input and Print

Every useful program needs to communicate with users. In Python, `print()` sends output to the screen and `input()` reads what the user types.

### The `print()` Function

Basic printing:

```python
print("Hello, World!")
print(42)
print(3.14)
print(True)
```

Printing multiple values on one line:

```python
name = "Sam"
age = 13

print("Name:", name, "Age:", age)
# Name: Sam Age: 13
```

### The `sep` Parameter

`sep` controls what goes *between* the items you print (default is a space):

```python
print("apple", "banana", "cherry")
# apple banana cherry

print("apple", "banana", "cherry", sep=", ")
# apple, banana, cherry

print("2024", "01", "15", sep="-")
# 2024-01-15

print("a", "b", "c", sep="")
# abc
```

### The `end` Parameter

`end` controls what goes at the *end* of the print (default is a newline `\n`):

```python
print("Loading", end="")
print("...", end="")
print(" Done!")
# Loading... Done!

# Printing items on the same line with a loop
for i in range(5):
    print(i, end=" ")
print()   # move to next line
# 0 1 2 3 4
```

### The `input()` Function

`input()` pauses the program and waits for the user to type something. It always returns a **string**:

```python
name = input("What is your name? ")
print("Hello,", name)
```

When the user types `Jordan` and presses Enter:
```
What is your name? Jordan
Hello, Jordan
```

### Converting Input to Numbers

Since `input()` always returns a string, you must convert it if you want a number:

```python
age_text = input("How old are you? ")
age = int(age_text)   # convert to integer
next_year = age + 1
print("Next year you will be", next_year)
```

Or in one line:

```python
age = int(input("How old are you? "))
height = float(input("Your height in metres? "))
print(f"Age: {age}, Height: {height}m")
```

### Build a Name Greeter

Here is a complete interactive program:

```python
# Name Greeter Program

print("=" * 30)
print("   WELCOME TO NAME GREETER")
print("=" * 30)

first_name = input("Enter your first name: ")
last_name = input("Enter your last name: ")
age = int(input("Enter your age: "))

full_name = first_name + " " + last_name

print()
print("Hello,", full_name + "!")
print("You are", age, "years old.")
print("In 10 years you will be", age + 10)
print("Nice to meet you!")
```

Sample run:
```
==============================
   WELCOME TO NAME GREETER
==============================
Enter your first name: Alex
Enter your last name: Chen
Enter your age: 13

Hello, Alex Chen!
You are 13 years old.
In 10 years you will be 23
Nice to meet you!
```

### Escape Characters in Strings

```python
print("She said \"hello\"")   # She said "hello"
print("Line one\nLine two")    # two lines
print("Tab\there")             # Tab    here
print("Backslash: \\")         # Backslash: \
```

### Activity: Personal Profile Generator

```python
print("=== PERSONAL PROFILE GENERATOR ===")

name = input("Your name: ")
age = int(input("Your age: "))
city = input("Your city: ")
hobby = input("Your favourite hobby: ")
fav_number = int(input("Your favourite number: "))

print()
print("=" * 40)
print(f"  PROFILE: {name.upper()}")
print("=" * 40)
print(f"  Age:    {age} years old")
print(f"  City:   {city}")
print(f"  Hobby:  {hobby}")
print(f"  Lucky#: {fav_number}")
print(f"  Fun fact: {fav_number} doubled is {fav_number * 2}")
print("=" * 40)
```

### Key Takeaways

- `print()` outputs to the screen; use `sep=` and `end=` to control formatting
- `input()` always returns a **string**
- Convert input to numbers using `int()` or `float()`
- `\n` is a newline, `\t` is a tab inside strings
- Multiplying a string by a number repeats it: `"=" * 20` gives 20 equals signs'),

('dev-l34', 'Python Strings: Slicing and Methods', 'developers', 'Python', 'en', 'intermediate', 40, 150, 34,
'## Python Strings: Slicing and Methods

Strings are sequences of characters, and Python gives you powerful tools to work with them. You can slice them, search them, transform them, and split them.

### String Indexing

Every character in a string has an index number starting at 0:

```python
word = "Python"
#       P  y  t  h  o  n
# index 0  1  2  3  4  5
# neg  -6 -5 -4 -3 -2 -1

print(word[0])   # P
print(word[3])   # h
print(word[-1])  # n (last character)
print(word[-2])  # o (second from last)
```

### String Slicing `[start:end:step]`

Slicing extracts a portion of a string:

```python
text = "Hello, World!"
#       0123456789...

print(text[0:5])    # Hello  (index 0 up to but not including 5)
print(text[7:12])   # World
print(text[:5])     # Hello  (start from beginning)
print(text[7:])     # World! (go to end)
print(text[:])      # Hello, World! (full copy)

# Step parameter
print(text[::2])    # Hlo ol!  (every 2nd character)
print(text[::-1])   # !dlroW ,olleH  (reversed!)
```

### Common String Methods

These methods do **not** change the original string — they return a new one:

```python
message = "  Hello, Python World!  "

print(message.upper())     # "  HELLO, PYTHON WORLD!  "
print(message.lower())     # "  hello, python world!  "
print(message.strip())     # "Hello, Python World!" (removes spaces from both ends)
print(message.lstrip())    # removes spaces from left only
print(message.rstrip())    # removes spaces from right only
```

### split() and join()

```python
sentence = "the cat sat on the mat"

# split turns a string into a list of words
words = sentence.split()
print(words)       # [''the'', ''cat'', ''sat'', ''on'', ''the'', ''mat'']
print(len(words))  # 6

# Split on a specific character
csv_line = "Alice,13,London,Coding"
parts = csv_line.split(",")
print(parts)  # [''Alice'', ''13'', ''London'', ''Coding'']

# join turns a list back into a string
joined = " - ".join(parts)
print(joined)  # Alice - 13 - London - Coding
```

### replace() and find()

```python
text = "I love cats and cats love me"

# replace(old, new)
new_text = text.replace("cats", "dogs")
print(new_text)   # I love dogs and dogs love me

# replace only first occurrence
first_only = text.replace("cats", "dogs", 1)
print(first_only) # I love dogs and cats love me

# find() returns the index of the first match (-1 if not found)
print(text.find("cats"))   # 7
print(text.find("fish"))   # -1
print("cats" in text)      # True (easier way to check!)
```

### More Useful Methods

```python
s = "Hello, World!"

print(s.startswith("Hello"))  # True
print(s.endswith("!"))        # True
print(s.count("l"))           # 3
print(s.title())              # "Hello, World!" (Title Case)
print(s.isdigit())            # False
print("12345".isdigit())      # True
print(s.replace(",", ""))     # "Hello World!"

# center, ljust, rjust for alignment
print("Python".center(20, "-"))   # -------Python-------
print("Python".ljust(20, "."))    # Python..............
print("Python".rjust(20, "."))    # ..............Python
```

### String Formatting (f-strings)

```python
name = "Alex"
age = 13
score = 95.678

print(f"Name: {name}")
print(f"Age:  {age}")
print(f"Score: {score:.1f}")   # 1 decimal place: 95.7
print(f"Score: {score:.0f}")   # 0 decimal places: 96
```

### Activity: Text Analyser

```python
text = input("Enter a sentence: ")

print()
print("=== TEXT ANALYSIS ===")
print(f"Original:   {text}")
print(f"Uppercase:  {text.upper()}")
print(f"Lowercase:  {text.lower()}")
print(f"Characters: {len(text)}")
print(f"Characters (no spaces): {len(text.replace('' '', ''))}")
print(f"Words:      {len(text.split())}")
print(f"Reversed:   {text[::-1]}")
print(f"Starts with vowel: {text[0].lower() in ''aeiou''}")
```

### Key Takeaways

- String indexes start at 0; negative indexes count from the end
- Slicing syntax: `string[start:end:step]`
- Key methods: `.upper()` `.lower()` `.strip()` `.split()` `.join()` `.replace()` `.find()`
- Strings are **immutable** — methods return new strings, never changing the original
- Use `in` to check if a substring exists: `"cat" in "concatenate"`'),

('dev-l35', 'Python Numbers and Maths', 'developers', 'Python', 'en', 'intermediate', 35, 150, 35,
'## Python Numbers and Maths

Python is excellent at maths. It handles everything from simple sums to scientific calculations, and its `math` module gives you access to dozens of mathematical functions.

### Types of Numbers

```python
# Integer (int) — whole numbers, no size limit!
a = 42
b = -17
big = 99999999999999999999   # Python handles huge numbers fine

# Float — decimal numbers
pi = 3.14159
price = 9.99
tiny = 0.000001

# Complex (bonus!) — numbers with imaginary parts
c = 3 + 4j
print(c.real)   # 3.0
print(c.imag)   # 4.0
```

### Arithmetic Operators

```python
a = 17
b = 5

print(a + b)    # 22  — addition
print(a - b)    # 12  — subtraction
print(a * b)    # 85  — multiplication
print(a / b)    # 3.4 — division (always gives float)
print(a // b)   # 3   — floor division (whole number, rounds down)
print(a % b)    # 2   — modulo (remainder)
print(a ** b)   # 1419857 — exponentiation (17 to the power 5)
```

### Floor Division and Modulo in Practice

```python
# How many full boxes of 6 can you pack from 25 apples?
apples = 25
box_size = 6
full_boxes = apples // box_size   # 4
leftover = apples % box_size      # 1
print(f"{full_boxes} full boxes, {leftover} left over")

# Is a number even or odd?
number = 17
if number % 2 == 0:
    print("Even")
else:
    print("Odd")   # prints Odd
```

### The `math` Module

Python''s built-in `math` module gives you advanced mathematical tools:

```python
import math

# Basic functions
print(math.sqrt(16))      # 4.0  — square root
print(math.floor(3.9))    # 3    — round down
print(math.ceil(3.1))     # 4    — round up
print(math.round(3.5))    # error! — use built-in round() instead
print(round(3.5))         # 4
print(round(3.14159, 2))  # 3.14 — round to 2 decimal places

# Constants
print(math.pi)    # 3.141592653589793
print(math.e)     # 2.718281828459045 (Euler''s number)
print(math.inf)   # infinity!

# Logarithms and powers
print(math.log(100, 10))  # 2.0  — log base 10 of 100
print(math.log2(8))       # 3.0  — log base 2 of 8
print(math.pow(2, 10))    # 1024.0

# Trigonometry
print(math.sin(math.pi / 2))  # 1.0
print(math.cos(0))            # 1.0
print(math.degrees(math.pi))  # 180.0
print(math.radians(180))      # 3.14159...
```

### Built-in Number Functions

```python
numbers = [3, 1, 4, 1, 5, 9, 2, 6]

print(abs(-7))          # 7 — absolute value
print(max(numbers))     # 9
print(min(numbers))     # 1
print(sum(numbers))     # 31
print(pow(2, 8))        # 256 — same as 2 ** 8
print(divmod(17, 5))    # (3, 2) — returns (quotient, remainder) together
```

### Integer vs Float Division

```python
print(10 / 3)    # 3.3333... (float division)
print(10 // 3)   # 3 (floor division, always int)
print(-10 // 3)  # -4 (rounds toward negative infinity!)

# Converting between types
print(int(3.9))    # 3 (truncates, does NOT round)
print(float(5))    # 5.0
print(round(3.9))  # 4 (actually rounds)
```

### Activity: Geometry Calculator

```python
import math

print("=== GEOMETRY CALCULATOR ===")

# Circle
radius = float(input("Enter radius of a circle: "))
area = math.pi * radius ** 2
circumference = 2 * math.pi * radius
print(f"Circle area: {area:.2f}")
print(f"Circumference: {circumference:.2f}")

# Right triangle (Pythagorean theorem)
a = float(input("Enter side a of right triangle: "))
b = float(input("Enter side b of right triangle: "))
hypotenuse = math.sqrt(a**2 + b**2)
print(f"Hypotenuse: {hypotenuse:.2f}")
```

### Key Takeaways

- Python has three number types: `int`, `float`, and `complex`
- `//` is floor division (whole number result), `%` is modulo (remainder), `**` is power
- `import math` unlocks `sqrt`, `floor`, `ceil`, `pi`, `sin`, `cos`, and much more
- `round()`, `abs()`, `max()`, `min()`, `sum()` are built-in without any import
- Integer division (`/`) always returns a float in Python 3'),

('dev-l36', 'Python Booleans and Comparisons', 'developers', 'Python', 'en', 'intermediate', 35, 150, 36,
'## Python Booleans and Comparisons

Booleans are the foundation of every decision in code. When Python evaluates a condition, the answer is always one of two values: `True` or `False`.

### Boolean Basics

```python
is_sunny = True
is_raining = False

print(is_sunny)         # True
print(is_raining)       # False
print(type(is_sunny))   # <class ''bool''>

# Note: Python capitalises True and False
# JavaScript uses lowercase true/false — Python does NOT!
```

### Comparison Operators

These operators compare two values and return a boolean:

```python
x = 10
y = 3

print(x == y)    # False — equal to
print(x != y)    # True  — not equal to
print(x > y)     # True  — greater than
print(x < y)     # False — less than
print(x >= 10)   # True  — greater than or equal
print(x <= 9)    # False — less than or equal
```

Comparing strings:

```python
print("apple" == "apple")   # True
print("apple" == "Apple")   # False (case sensitive!)
print("apple" < "banana")   # True (alphabetical order)
print("z" > "a")            # True
```

### Logical Operators: `and`, `or`, `not`

```python
age = 14
has_ticket = True

# and — both must be True
print(age >= 12 and has_ticket)   # True
print(age >= 18 and has_ticket)   # False

# or — at least one must be True
print(age >= 18 or has_ticket)    # True
print(age >= 18 or age >= 21)     # False

# not — flips True to False and vice versa
print(not is_raining)       # True (if is_raining is False)
print(not (age >= 18))      # True (age is NOT >= 18)
```

### Chaining Comparisons

Python lets you chain comparisons in a natural way:

```python
score = 75

# Python style (very readable):
print(70 <= score <= 79)    # True — is score in the 70s?

# Equivalent to:
print(score >= 70 and score <= 79)  # same result

age = 14
print(12 <= age <= 17)      # True — is age a teen?
```

### Truthiness and Falsiness

In Python, many non-boolean values can be used as booleans. Some values are **falsy** (treated as False):

```python
# Falsy values:
print(bool(0))        # False
print(bool(0.0))      # False
print(bool(""))       # False (empty string)
print(bool([]))       # False (empty list)
print(bool(None))     # False

# Truthy values (everything else):
print(bool(1))        # True
print(bool(-1))       # True (any non-zero number)
print(bool("hello"))  # True (any non-empty string)
print(bool([1,2]))    # True (any non-empty list)
```

This matters in `if` statements:

```python
name = input("Enter your name: ")

if name:   # truthy — only True if name is not empty
    print(f"Hello, {name}!")
else:
    print("You didn''t enter a name!")
```

### `is` vs `==`

```python
# == checks if values are equal
# is checks if they are the exact same object in memory

a = [1, 2, 3]
b = [1, 2, 3]
c = a

print(a == b)   # True (same values)
print(a is b)   # False (different objects)
print(a is c)   # True (same object!)

# Always use == for comparisons
# Use "is" only for None checks:
result = None
if result is None:
    print("No result yet")
```

### Activity: Ticket Checker

```python
print("=== THEME PARK TICKET CHECKER ===")

age = int(input("Enter your age: "))
height_cm = int(input("Enter your height in cm: "))
has_ticket = input("Do you have a ticket? (yes/no): ").lower() == "yes"

# Check eligibility for different rides
big_coaster = age >= 12 and height_cm >= 140 and has_ticket
kids_ride = age <= 10 and has_ticket
any_ride = has_ticket

print()
print(f"Has ticket: {has_ticket}")
print(f"Can ride big coaster: {big_coaster}")
print(f"Can ride kids'' rides: {kids_ride}")
print(f"Eligible for any ride: {any_ride}")
```

### Key Takeaways

- Python booleans are `True` and `False` (capital T and F!)
- Comparison operators: `==`, `!=`, `<`, `>`, `<=`, `>=`
- Logical operators: `and`, `or`, `not` (Python uses words, not `&&`, `||`, `!`)
- Chain comparisons naturally: `10 <= x <= 20`
- Many values have truthiness: `0`, `""`, `[]`, `None` are all falsy'),

('dev-l37', 'Python If, Elif, Else', 'developers', 'Python', 'en', 'intermediate', 40, 150, 37,
'## Python If, Elif, Else

Decision-making is at the heart of every program. Python''s `if`, `elif`, and `else` statements let your code follow different paths based on conditions.

### Basic `if` Statement

```python
temperature = 28

if temperature > 25:
    print("It''s hot outside!")
    print("Wear sunscreen!")

# If the condition is False, nothing happens
```

**Important:** Python uses **indentation** (4 spaces) to show which code belongs inside the `if`. There are no curly braces!

### `if` ... `else`

```python
score = 55

if score >= 50:
    print("You passed!")
else:
    print("You need to retake the test.")
```

### `if` ... `elif` ... `else`

`elif` means "else if" — check another condition if the first was False:

```python
hour = 14  # 2pm

if hour < 12:
    print("Good morning!")
elif hour < 17:
    print("Good afternoon!")
elif hour < 21:
    print("Good evening!")
else:
    print("Good night!")
```

### Grade Calculator

A classic example — converting a score to a letter grade:

```python
def get_grade(score):
    if score >= 90:
        return "A"
    elif score >= 80:
        return "B"
    elif score >= 70:
        return "C"
    elif score >= 60:
        return "D"
    else:
        return "F"

# Test it
print(get_grade(95))   # A
print(get_grade(83))   # B
print(get_grade(71))   # C
print(get_grade(65))   # D
print(get_grade(42))   # F
```

### Nested `if` Statements

You can put an `if` inside another `if`:

```python
age = 15
has_id = True

if age >= 13:
    print("Old enough to sign up")
    if has_id:
        print("ID verified — account created!")
    else:
        print("Please bring ID to verify your account.")
else:
    print("Sorry, you must be at least 13.")
```

Keep nesting shallow (2 levels max) to keep code readable.

### One-Line `if` (Ternary Expression)

```python
age = 15
status = "adult" if age >= 18 else "minor"
print(status)   # minor

# Another example
score = 72
result = "pass" if score >= 50 else "fail"
print(result)   # pass
```

### Multiple Conditions

```python
username = "alex"
password = "secret123"

if username == "alex" and password == "secret123":
    print("Login successful!")
elif username == "alex":
    print("Wrong password!")
else:
    print("Unknown user!")
```

### `in` with `if`

```python
vowels = "aeiou"
letter = "e"

if letter in vowels:
    print(f"{letter} is a vowel")
else:
    print(f"{letter} is a consonant")

# Also works with lists
allowed_colours = ["red", "blue", "green"]
colour = input("Choose a colour: ")

if colour in allowed_colours:
    print(f"Great choice: {colour}")
else:
    print(f"Sorry, {colour} is not available")
```

### Activity: Interactive Grade Calculator

```python
print("=== GRADE CALCULATOR ===")

name = input("Student name: ")
score = float(input(f"Enter {name}''s score (0-100): "))

if not (0 <= score <= 100):
    print("Error: score must be between 0 and 100")
else:
    if score >= 90:
        grade = "A"
        comment = "Outstanding!"
    elif score >= 80:
        grade = "B"
        comment = "Great work!"
    elif score >= 70:
        grade = "C"
        comment = "Good effort."
    elif score >= 60:
        grade = "D"
        comment = "Needs improvement."
    else:
        grade = "F"
        comment = "Please see your teacher."

    print()
    print(f"Student: {name}")
    print(f"Score:   {score:.1f}%")
    print(f"Grade:   {grade}")
    print(f"Comment: {comment}")
```

### Key Takeaways

- Python uses indentation (4 spaces) to define code blocks — no `{}`
- `elif` is Python''s way of saying "else if"
- You can nest `if` statements, but keep it to 2 levels for readability
- The ternary expression `x if condition else y` gives a one-liner if/else
- `in` is great for checking membership in strings, lists, and other collections'),

('dev-l38', 'Python While Loops', 'developers', 'Python', 'en', 'intermediate', 40, 150, 38,
'## Python While Loops

A `while` loop keeps running a block of code **as long as** a condition is true. It is perfect when you do not know in advance how many times something needs to repeat.

### Basic `while` Loop

```python
count = 1

while count <= 5:
    print(f"Count: {count}")
    count += 1   # IMPORTANT: always update the condition or you''ll loop forever!

print("Done!")
```

Output:
```
Count: 1
Count: 2
Count: 3
Count: 4
Count: 5
Done!
```

### The Infinite Loop (and how to avoid it)

A loop that never ends is called an **infinite loop**. It happens when the condition never becomes False:

```python
# DANGER — infinite loop!
# x = 1
# while x > 0:
#     print(x)   # x never changes, so this runs forever

# FIX — always make progress toward False:
x = 10
while x > 0:
    print(x)
    x -= 1   # x decreases each time
```

Press `Ctrl + C` to stop an infinite loop in the terminal.

### `break`: Exit the Loop Early

`break` immediately stops the loop, even if the condition is still True:

```python
while True:   # this would be infinite...
    answer = input("Type ''quit'' to exit: ")
    if answer == "quit":
        break    # ...but break stops it!
    print(f"You typed: {answer}")

print("Goodbye!")
```

### `continue`: Skip to the Next Iteration

`continue` skips the rest of the current loop body and jumps back to the condition check:

```python
number = 0

while number < 10:
    number += 1
    if number % 2 == 0:
        continue    # skip even numbers
    print(number)   # only prints odd numbers: 1 3 5 7 9
```

### `else` on a `while` Loop

Python''s `while` can have an `else` clause that runs when the loop ends **normally** (not via `break`):

```python
attempts = 0
max_attempts = 3
correct_password = "python123"

while attempts < max_attempts:
    guess = input("Enter password: ")
    if guess == correct_password:
        print("Access granted!")
        break
    attempts += 1
    print(f"Wrong! {max_attempts - attempts} attempts left.")
else:
    print("Account locked. Too many failed attempts.")
```

### Number Guessing Game

Here is a complete game using a `while` loop:

```python
import random

secret = random.randint(1, 100)
guesses = 0
max_guesses = 7

print("I''m thinking of a number between 1 and 100.")
print(f"You have {max_guesses} guesses. Good luck!")

while guesses < max_guesses:
    guess = int(input(f"Guess {guesses + 1}: "))
    guesses += 1

    if guess == secret:
        print(f"Correct! You got it in {guesses} guesses!")
        break
    elif guess < secret:
        print("Too low!")
    else:
        print("Too high!")
else:
    print(f"Out of guesses! The number was {secret}.")
```

### Input Validation with `while`

A common pattern is using `while` to keep asking until the user provides valid input:

```python
while True:
    age_text = input("Enter your age (1-120): ")

    if age_text.isdigit():
        age = int(age_text)
        if 1 <= age <= 120:
            break   # valid input — exit the loop
        else:
            print("Age must be between 1 and 120.")
    else:
        print("Please enter a whole number.")

print(f"Your age is {age}")
```

### Counting with `while`

```python
# Sum all numbers from 1 to 100
total = 0
i = 1

while i <= 100:
    total += i
    i += 1

print(f"Sum of 1 to 100 = {total}")   # 5050
```

### Key Takeaways

- `while condition:` repeats as long as condition is True
- Always update your condition variable inside the loop to avoid infinite loops
- `break` exits the loop immediately
- `continue` skips the rest of the current iteration
- `while ... else:` runs the `else` block when the loop finishes normally (no `break`)
- Use `while True:` with `break` for "keep going until valid input" patterns'),

('dev-l39', 'Python For Loops and Range', 'developers', 'Python', 'en', 'intermediate', 40, 150, 39,
'## Python For Loops and Range

The `for` loop is Python''s most-used loop. It iterates over any sequence — a list, a string, a range of numbers, or more — without needing to manage a counter variable yourself.

### Basic `for` Loop

```python
fruits = ["apple", "banana", "cherry", "mango"]

for fruit in fruits:
    print(fruit)
```

Output:
```
apple
banana
cherry
mango
```

The variable `fruit` takes each value from the list one at a time.

### Iterating Over a String

```python
word = "Python"

for letter in word:
    print(letter, end=" ")   # P y t h o n
```

### The `range()` Function

`range()` generates a sequence of numbers without creating a list in memory:

```python
# range(stop) — 0 up to (but not including) stop
for i in range(5):
    print(i, end=" ")    # 0 1 2 3 4

# range(start, stop)
for i in range(3, 8):
    print(i, end=" ")    # 3 4 5 6 7

# range(start, stop, step)
for i in range(0, 20, 4):
    print(i, end=" ")    # 0 4 8 12 16

# Count backwards
for i in range(10, 0, -1):
    print(i, end=" ")    # 10 9 8 7 6 5 4 3 2 1
```

### `enumerate()` — Loop with Index

When you need both the index and the value:

```python
animals = ["cat", "dog", "bird", "fish"]

for index, animal in enumerate(animals):
    print(f"{index}: {animal}")
```

Output:
```
0: cat
1: dog
2: bird
3: fish
```

Start the index at 1:

```python
for num, animal in enumerate(animals, start=1):
    print(f"{num}. {animal}")
```

### `zip()` — Loop Over Two Lists at Once

```python
names = ["Alice", "Bob", "Carol"]
scores = [88, 72, 95]

for name, score in zip(names, scores):
    print(f"{name}: {score}")
```

Output:
```
Alice: 88
Bob: 72
Carol: 95
```

### Nested Loops

A loop inside a loop:

```python
# Times table
for row in range(1, 6):
    for col in range(1, 6):
        product = row * col
        print(f"{product:3}", end="")
    print()   # new line after each row
```

Output:
```
  1  2  3  4  5
  2  4  6  8 10
  3  6  9 12 15
  4  8 12 16 20
  5 10 15 20 25
```

### `break` and `continue` in `for` Loops

```python
# break — stop early
for i in range(10):
    if i == 5:
        break
    print(i, end=" ")    # 0 1 2 3 4

# continue — skip one iteration
for i in range(10):
    if i % 2 == 0:
        continue
    print(i, end=" ")    # 1 3 5 7 9
```

### Activity: Times Table Generator

```python
number = int(input("Generate times table for: "))

print(f"\n=== {number} TIMES TABLE ===")
for i in range(1, 13):
    result = number * i
    print(f"{number} x {i:2} = {result}")
```

Sample output for 7:
```
=== 7 TIMES TABLE ===
7 x  1 = 7
7 x  2 = 14
...
7 x 12 = 84
```

### Looping Over a Dictionary

```python
person = {"name": "Sam", "age": 14, "city": "Dublin"}

for key in person:
    print(key, ":", person[key])

# Or more Pythonically:
for key, value in person.items():
    print(f"  {key}: {value}")
```

### Key Takeaways

- `for item in sequence:` loops over every item in the sequence
- `range(stop)`, `range(start, stop)`, `range(start, stop, step)` generate number sequences
- `enumerate()` gives you both the index and value
- `zip()` lets you loop two lists in parallel
- `break` exits early; `continue` skips to the next iteration
- Nested loops work, but watch out for performance with very large ranges'),

('dev-l40', 'Python Lists', 'developers', 'Python', 'en', 'intermediate', 40, 150, 40,
'## Python Lists

A list is an ordered, changeable collection of items. It is one of the most important data structures in Python and you will use lists in almost every program you write.

### Creating Lists

```python
# Empty list
empty = []

# List of strings
fruits = ["apple", "banana", "cherry"]

# List of numbers
scores = [85, 92, 78, 95, 88]

# Mixed types (possible but uncommon)
mixed = ["Alice", 13, True, 3.14]

# List of lists (2D list)
grid = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]
```

### Accessing Items

```python
colours = ["red", "green", "blue", "yellow"]

print(colours[0])    # red (first item)
print(colours[1])    # green
print(colours[-1])   # yellow (last item)
print(colours[-2])   # blue (second from last)
```

### Slicing Lists

```python
numbers = [10, 20, 30, 40, 50, 60, 70]

print(numbers[0:3])    # [10, 20, 30]
print(numbers[2:5])    # [30, 40, 50]
print(numbers[:4])     # [10, 20, 30, 40]
print(numbers[4:])     # [50, 60, 70]
print(numbers[::2])    # [10, 30, 50, 70] (every 2nd item)
print(numbers[::-1])   # [70, 60, 50, 40, 30, 20, 10] (reversed!)
```

### Useful List Functions

```python
nums = [5, 2, 8, 1, 9, 3]

print(len(nums))     # 6 — number of items
print(max(nums))     # 9 — largest value
print(min(nums))     # 1 — smallest value
print(sum(nums))     # 28 — total

# Check membership with in
print(8 in nums)     # True
print(7 in nums)     # False
print(7 not in nums) # True
```

### Changing Lists

Lists are **mutable** — you can change them after creation:

```python
colours = ["red", "green", "blue"]

# Change an item
colours[1] = "orange"
print(colours)    # [''red'', ''orange'', ''blue'']

# Change a slice
colours[0:2] = ["pink", "purple"]
print(colours)    # [''pink'', ''purple'', ''blue'']
```

### List of Lists (2D)

```python
classroom = [
    ["Alice", 88],
    ["Bob", 75],
    ["Carol", 92]
]

# Access nested items
print(classroom[0][0])   # Alice
print(classroom[0][1])   # 88
print(classroom[2][1])   # 92

# Print all students
for student in classroom:
    print(f"{student[0]}: {student[1]}")
```

### Copying a List

Be careful — assigning a list to a new variable does NOT copy it:

```python
original = [1, 2, 3]
not_a_copy = original      # both point to same list!
not_a_copy.append(4)
print(original)            # [1, 2, 3, 4] — original changed too!

# Make a real copy:
real_copy = original.copy()   # method 1
real_copy2 = original[:]       # method 2
real_copy3 = list(original)    # method 3
```

### Activity: Student Scores Tracker

```python
scores = []

print("Enter up to 5 student scores (type ''done'' to stop):")

while len(scores) < 5:
    entry = input(f"Score {len(scores) + 1}: ")
    if entry.lower() == "done":
        break
    if entry.isdigit():
        scores.append(int(entry))
    else:
        print("Please enter a number.")

if scores:
    print(f"\nScores: {scores}")
    print(f"Count:   {len(scores)}")
    print(f"Highest: {max(scores)}")
    print(f"Lowest:  {min(scores)}")
    print(f"Average: {sum(scores) / len(scores):.1f}")
else:
    print("No scores entered.")
```

### Key Takeaways

- Lists are ordered, mutable, and can hold any types
- Indexing starts at 0; negative indexes count from the end
- Slicing creates a new list with a portion of the original
- `len()`, `max()`, `min()`, `sum()` are built-in list tools
- Use `in` to check membership
- Assigning a list to a variable copies the reference, not the data — use `.copy()` for a real copy')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO public.lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES

('dev-l41', 'Python List Methods', 'developers', 'Python', 'en', 'intermediate', 40, 150, 41,
'## Python List Methods

Lists come with a powerful set of built-in methods. Knowing them saves you from writing complex loops and makes your code much more readable.

### Adding Items

```python
shopping = ["milk", "eggs", "bread"]

# append() — add one item to the end
shopping.append("butter")
print(shopping)   # [''milk'', ''eggs'', ''bread'', ''butter'']

# insert(index, item) — add at a specific position
shopping.insert(1, "cheese")
print(shopping)   # [''milk'', ''cheese'', ''eggs'', ''bread'', ''butter'']

# extend() — add all items from another list
extras = ["juice", "yogurt"]
shopping.extend(extras)
print(shopping)   # [''milk'', ''cheese'', ''eggs'', ''bread'', ''butter'', ''juice'', ''yogurt'']
```

### Removing Items

```python
items = ["cat", "dog", "bird", "cat", "fish"]

# remove() — removes the FIRST matching item
items.remove("cat")
print(items)   # [''dog'', ''bird'', ''cat'', ''fish'']

# pop() — removes and returns item at index (default: last item)
last = items.pop()
print(last)    # fish
print(items)   # [''dog'', ''bird'', ''cat'']

second = items.pop(1)
print(second)  # bird
print(items)   # [''dog'', ''cat'']

# del — delete by index or slice
colours = ["red", "green", "blue", "yellow"]
del colours[1]
print(colours)   # [''red'', ''blue'', ''yellow'']

# clear() — remove everything
colours.clear()
print(colours)   # []
```

### Sorting and Reversing

```python
numbers = [5, 2, 8, 1, 9, 3]

# sort() — sorts IN PLACE (changes the original list)
numbers.sort()
print(numbers)   # [1, 2, 3, 5, 8, 9]

numbers.sort(reverse=True)
print(numbers)   # [9, 8, 5, 3, 2, 1]

# sorted() — returns a NEW sorted list (original unchanged)
original = [5, 2, 8, 1, 9, 3]
new_sorted = sorted(original)
print(original)    # [5, 2, 8, 1, 9, 3] — unchanged!
print(new_sorted)  # [1, 2, 3, 5, 8, 9]

# reverse() — reverses IN PLACE
words = ["banana", "apple", "cherry"]
words.reverse()
print(words)   # [''cherry'', ''apple'', ''banana'']
```

### Searching and Counting

```python
scores = [88, 75, 92, 75, 88, 100, 75]

# index() — returns the index of the FIRST occurrence
print(scores.index(75))    # 1
print(scores.index(100))   # 5

# count() — how many times does a value appear?
print(scores.count(75))    # 3
print(scores.count(88))    # 2

# copy() — shallow copy of the list
backup = scores.copy()
```

### Sorting Strings

```python
animals = ["zebra", "ant", "elephant", "bee"]
animals.sort()
print(animals)   # [''ant'', ''bee'', ''elephant'', ''zebra'']

# Case-insensitive sort
words = ["Banana", "apple", "Cherry"]
words.sort(key=str.lower)
print(words)     # [''apple'', ''Banana'', ''Cherry'']
```

### Activity: Shopping List App

```python
shopping_list = []

print("=== SHOPPING LIST ===")
print("Commands: add, remove, view, sort, quit")

while True:
    command = input("\nCommand: ").lower().strip()

    if command == "add":
        item = input("Item to add: ").strip()
        if item:
            shopping_list.append(item)
            print(f"Added: {item}")

    elif command == "remove":
        item = input("Item to remove: ").strip()
        if item in shopping_list:
            shopping_list.remove(item)
            print(f"Removed: {item}")
        else:
            print(f"{item} not in list!")

    elif command == "view":
        if shopping_list:
            print("Your list:")
            for i, item in enumerate(shopping_list, 1):
                print(f"  {i}. {item}")
        else:
            print("List is empty!")

    elif command == "sort":
        shopping_list.sort()
        print("List sorted!")

    elif command == "quit":
        print(f"Goodbye! You had {len(shopping_list)} items.")
        break
    else:
        print("Unknown command.")
```

### Key Takeaways

- `append()` adds to end; `insert(i, item)` adds at position; `extend()` adds many
- `remove(value)` removes by value; `pop(i)` removes by index and returns it
- `sort()` modifies in place; `sorted()` returns a new list
- `index(value)` finds position; `count(value)` counts occurrences
- Always use `copy()` when you need a real independent copy of a list'),

('dev-l42', 'Python Tuples', 'developers', 'Python', 'en', 'intermediate', 35, 150, 42,
'## Python Tuples

A tuple is like a list, but with one crucial difference: tuples are **immutable** — you cannot change them after creation. This makes them perfect for data that should never be modified.

### Creating Tuples

```python
# Use parentheses instead of square brackets
point = (3, 5)
rgb = (255, 128, 0)
empty = ()

# Single-item tuple (needs a trailing comma!)
single = (42,)    # This is a tuple
not_tuple = (42)  # This is just the number 42!

print(type(single))    # <class ''tuple''>
print(type(not_tuple)) # <class ''int''>
```

### Accessing Tuple Items

Tuples support the same indexing and slicing as lists:

```python
coordinates = (10, 20, 30, 40, 50)

print(coordinates[0])    # 10
print(coordinates[-1])   # 50
print(coordinates[1:4])  # (20, 30, 40)
print(len(coordinates))  # 5
print(30 in coordinates) # True
```

### Why Use Tuples? Immutability

```python
settings = ("localhost", 8080, "production")

# This would cause an error:
# settings[1] = 9090   # TypeError: ''tuple'' does not support item assignment

# Tuples protect important data from accidental changes!
```

Tuples are also slightly faster than lists and can be used as dictionary keys (lists cannot):

```python
# Tuples as dictionary keys
locations = {
    (51.5, -0.1): "London",
    (48.8, 2.3): "Paris",
    (40.7, -74.0): "New York"
}
print(locations[(51.5, -0.1)])   # London
```

### Tuple Packing and Unpacking

**Packing** — combine values into a tuple:

```python
person = "Alice", 14, "London"   # parentheses optional!
print(person)   # (''Alice'', 14, ''London'')
```

**Unpacking** — extract values from a tuple:

```python
name, age, city = person
print(name)   # Alice
print(age)    # 14
print(city)   # London
```

The number of variables must match the tuple length (unless you use `*`):

```python
first, *rest = (1, 2, 3, 4, 5)
print(first)  # 1
print(rest)   # [2, 3, 4, 5]

*start, last = (1, 2, 3, 4, 5)
print(start)  # [1, 2, 3, 4]
print(last)   # 5
```

### Functions Returning Multiple Values

Python functions often return tuples to give back multiple results:

```python
def min_max(numbers):
    return min(numbers), max(numbers)   # returns a tuple

low, high = min_max([5, 2, 8, 1, 9])
print(f"Min: {low}, Max: {high}")   # Min: 1, Max: 9

def divide_with_remainder(a, b):
    return a // b, a % b

quotient, remainder = divide_with_remainder(17, 5)
print(f"17 ÷ 5 = {quotient} remainder {remainder}")
# 17 ÷ 5 = 3 remainder 2
```

### Converting Between List and Tuple

```python
my_list = [1, 2, 3, 4]
my_tuple = tuple(my_list)   # list → tuple
print(my_tuple)   # (1, 2, 3, 4)

back_to_list = list(my_tuple)  # tuple → list
back_to_list.append(5)
print(back_to_list)   # [1, 2, 3, 4, 5]
```

### Named Tuples (Bonus)

`namedtuple` from the `collections` module creates tuples where you can access fields by name:

```python
from collections import namedtuple

# Define a "Student" type
Student = namedtuple("Student", ["name", "age", "grade"])

alice = Student("Alice", 14, "B")
print(alice.name)    # Alice
print(alice.age)     # 14
print(alice.grade)   # B
print(alice[0])      # Alice (index access still works)
```

### Activity: Coordinate Geometry

```python
def distance(point1, point2):
    """Calculate distance between two (x, y) points."""
    import math
    x1, y1 = point1
    x2, y2 = point2
    return math.sqrt((x2 - x1)**2 + (y2 - y1)**2)

def midpoint(point1, point2):
    """Find the midpoint between two points."""
    x1, y1 = point1
    x2, y2 = point2
    return ((x1 + x2) / 2, (y1 + y2) / 2)

a = (0, 0)
b = (6, 8)

print(f"Distance: {distance(a, b):.2f}")      # 10.00
print(f"Midpoint: {midpoint(a, b)}")           # (3.0, 4.0)
```

### Key Takeaways

- Tuples use `()` and are **immutable** — you cannot change them
- Single-item tuples need a trailing comma: `(42,)`
- Unpacking assigns tuple values to variables: `x, y = (10, 20)`
- Functions can return multiple values as tuples
- Tuples are faster, safer, and can be used as dictionary keys — use them for fixed data'),

('dev-l43', 'Python Dictionaries', 'developers', 'Python', 'en', 'intermediate', 40, 150, 43,
'## Python Dictionaries

A dictionary stores data as **key-value pairs**, like a real dictionary where you look up a word (key) to find its definition (value). This is one of Python''s most powerful and frequently-used data structures.

### Creating Dictionaries

```python
# Empty dictionary
empty = {}

# Dictionary with initial data
person = {
    "name": "Alice",
    "age": 14,
    "city": "Dublin",
    "is_student": True
}

# Keys can be strings, numbers, or tuples
mixed_keys = {1: "one", 2: "two", "three": 3}
```

### Accessing Values

```python
person = {"name": "Alice", "age": 14, "city": "Dublin"}

# By key (raises KeyError if key doesn''t exist)
print(person["name"])    # Alice
print(person["age"])     # 14

# .get() is safer — returns None if key missing
print(person.get("city"))        # Dublin
print(person.get("email"))       # None
print(person.get("email", "N/A")) # N/A (custom default)
```

### Adding and Modifying

```python
person = {"name": "Alice", "age": 14}

# Add a new key
person["email"] = "alice@example.com"
print(person)

# Modify an existing value
person["age"] = 15
print(person["age"])   # 15

# Update with another dictionary
extra = {"city": "Dublin", "hobby": "coding"}
person.update(extra)
print(person)
```

### Removing Keys

```python
person = {"name": "Alice", "age": 14, "city": "Dublin", "email": "alice@ex.com"}

# del — remove by key
del person["email"]

# pop() — remove and return the value
age = person.pop("age")
print(f"Removed age: {age}")

# popitem() — remove and return last inserted key-value pair
key, value = person.popitem()
print(f"Removed: {key} = {value}")

# clear() — remove everything
person.clear()
```

### Looping Over Dictionaries

```python
scores = {"Alice": 88, "Bob": 75, "Carol": 92}

# Loop over keys (default)
for name in scores:
    print(name)

# Loop over values
for score in scores.values():
    print(score)

# Loop over key-value pairs (most useful!)
for name, score in scores.items():
    print(f"{name}: {score}")
```

### Dictionary Methods

```python
info = {"name": "Alice", "age": 14, "city": "Dublin"}

print(info.keys())     # dict_keys([''name'', ''age'', ''city''])
print(info.values())   # dict_values([''Alice'', 14, ''Dublin''])
print(info.items())    # dict_items([(''name'', ''Alice''), ...])

# Check if key exists
print("name" in info)      # True
print("email" in info)     # False

# Length
print(len(info))           # 3
```

### Nested Dictionaries

```python
students = {
    "alice": {"age": 14, "grade": "A", "score": 92},
    "bob":   {"age": 13, "grade": "B", "score": 78},
    "carol": {"age": 14, "grade": "A", "score": 95}
}

# Access nested data
print(students["alice"]["grade"])   # A
print(students["bob"]["score"])     # 78

# Loop through nested dict
for name, info in students.items():
    print(f"{name.title()}: Grade {info[''grade'']}, Score {info[''score'']}")
```

### Activity: Contact Book

```python
contacts = {}

print("=== CONTACT BOOK ===")
print("Commands: add, find, list, delete, quit")

while True:
    command = input("\n> ").lower().strip()

    if command == "add":
        name = input("Name: ").strip().lower()
        phone = input("Phone: ").strip()
        email = input("Email: ").strip()
        contacts[name] = {"phone": phone, "email": email}
        print(f"Contact saved: {name.title()}")

    elif command == "find":
        name = input("Search name: ").strip().lower()
        if name in contacts:
            info = contacts[name]
            print(f"Name:  {name.title()}")
            print(f"Phone: {info[''phone'']}")
            print(f"Email: {info[''email'']}")
        else:
            print("Contact not found.")

    elif command == "list":
        if contacts:
            for name, info in contacts.items():
                print(f"  {name.title()} — {info[''phone'']}")
        else:
            print("No contacts saved.")

    elif command == "delete":
        name = input("Delete name: ").strip().lower()
        if name in contacts:
            del contacts[name]
            print("Deleted.")
        else:
            print("Not found.")

    elif command == "quit":
        print(f"Goodbye! {len(contacts)} contacts saved.")
        break
```

### Key Takeaways

- Dictionaries store key-value pairs: `{"key": value}`
- Access with `dict["key"]` or safely with `dict.get("key", default)`
- Add/update with `dict["key"] = value`; remove with `del dict["key"]` or `.pop()`
- Loop with `.items()` to get both key and value
- Dictionaries are ordered (Python 3.7+) and very fast at lookups'),

('dev-l44', 'Python Sets', 'developers', 'Python', 'en', 'intermediate', 35, 150, 44,
'## Python Sets

A set is an **unordered collection of unique items**. Sets automatically remove duplicates, and they support powerful mathematical operations like union, intersection, and difference.

### Creating Sets

```python
# Using curly braces
fruits = {"apple", "banana", "cherry"}

# Using set()
numbers = set([1, 2, 3, 4, 5])

# IMPORTANT: {} creates an empty DICT, not a set!
empty_dict = {}        # <class ''dict''>
empty_set = set()      # <class ''set''>

print(type(empty_dict))   # <class ''dict''>
print(type(empty_set))    # <class ''set''>
```

### Sets Remove Duplicates Automatically

```python
# Any duplicates are removed immediately
tags = {"python", "coding", "python", "fun", "coding", "python"}
print(tags)   # {''fun'', ''coding'', ''python''} — only 3 unique items

# Great trick: remove duplicates from a list
numbers = [1, 2, 3, 2, 1, 4, 3, 5, 1]
unique = list(set(numbers))
print(unique)   # [1, 2, 3, 4, 5] (order may vary)
```

### Checking Membership

Sets are extremely fast at checking if an item exists — much faster than lists for large collections:

```python
banned_words = {"spam", "phishing", "malware", "scam"}
message_word = "spam"

if message_word in banned_words:
    print("Message blocked!")
else:
    print("Message allowed.")
```

### Adding and Removing

```python
skills = {"python", "javascript", "html"}

# Add one item
skills.add("css")
print(skills)

# Remove (raises error if not found)
skills.remove("html")

# Discard (safe — no error if not found)
skills.discard("java")   # does nothing, no error
skills.discard("python") # removes python

# Pop — removes and returns an arbitrary item
item = skills.pop()
print(f"Removed: {item}")
```

### Set Operations

Sets support the same operations as mathematical sets:

```python
class_a = {"Alice", "Bob", "Carol", "Dave"}
class_b = {"Bob", "Eve", "Carol", "Frank"}

# Union — all students in either class
print(class_a | class_b)
# or: class_a.union(class_b)

# Intersection — students in BOTH classes
print(class_a & class_b)           # {''Bob'', ''Carol''}
# or: class_a.intersection(class_b)

# Difference — in A but NOT in B
print(class_a - class_b)           # {''Alice'', ''Dave''}
# or: class_a.difference(class_b)

# Symmetric difference — in one but NOT both
print(class_a ^ class_b)           # {''Alice'', ''Dave'', ''Eve'', ''Frank''}
# or: class_a.symmetric_difference(class_b)
```

### Subset and Superset

```python
required = {"python", "html", "css"}
student_skills = {"python", "html", "css", "javascript", "react"}

# Is required a subset of student_skills?
print(required.issubset(student_skills))    # True
print(required <= student_skills)           # True (shorthand)

# Is student_skills a superset of required?
print(student_skills.issuperset(required))  # True
print(student_skills >= required)           # True

# Are they disjoint? (no common elements)
maths = {"algebra", "geometry"}
print(required.isdisjoint(maths))           # True
```

### Practical Use: Finding Duplicates

```python
def find_duplicates(items):
    seen = set()
    duplicates = set()
    for item in items:
        if item in seen:
            duplicates.add(item)
        else:
            seen.add(item)
    return duplicates

emails = ["a@b.com", "c@d.com", "a@b.com", "e@f.com", "c@d.com"]
dups = find_duplicates(emails)
print(f"Duplicate emails: {dups}")
```

### Activity: Common Interests

```python
person1 = input("Person 1''s hobbies (comma separated): ")
person2 = input("Person 2''s hobbies (comma separated): ")

hobbies1 = set(h.strip().lower() for h in person1.split(","))
hobbies2 = set(h.strip().lower() for h in person2.split(","))

common = hobbies1 & hobbies2
only1 = hobbies1 - hobbies2
only2 = hobbies2 - hobbies1

print(f"\nIn common: {common if common else ''nothing''}")
print(f"Only person 1: {only1}")
print(f"Only person 2: {only2}")
```

### Key Takeaways

- Sets are **unordered**, **unique** collections — great for removing duplicates
- Use `set()` to create an empty set (not `{}` which creates a dict)
- `add()` adds one item; `discard()` removes safely without errors
- Set operations: `|` union, `&` intersection, `-` difference, `^` symmetric difference
- Sets are very fast at `in` checks — perfect for large "allowed/blocked" collections'),

('dev-l45', 'Python Functions', 'developers', 'Python', 'en', 'intermediate', 40, 150, 45,
'## Python Functions

A function is a named block of reusable code. Instead of repeating the same logic over and over, you write it once as a function and call it whenever you need it. Good functions make code clean, readable, and easy to fix.

### Defining and Calling Functions

```python
# Define a function with def
def say_hello():
    print("Hello!")
    print("Welcome to Python functions.")

# Call it (run it)
say_hello()
say_hello()   # call it as many times as you like
```

### Functions with Parameters

```python
def greet(name):
    print(f"Hello, {name}!")

greet("Alice")   # Hello, Alice!
greet("Bob")     # Hello, Bob!
```

Multiple parameters:

```python
def introduce(name, age, city):
    print(f"My name is {name}, I am {age} years old, from {city}.")

introduce("Sam", 14, "London")
```

### Functions with Return Values

```python
def add(a, b):
    return a + b

result = add(5, 3)
print(result)   # 8

# The return value can be used directly
print(add(10, 20) * 2)   # 60
```

### Docstrings

Good functions have a description called a **docstring** on the first line:

```python
def celsius_to_fahrenheit(celsius):
    """Convert a temperature from Celsius to Fahrenheit."""
    return (celsius * 9 / 5) + 32

help(celsius_to_fahrenheit)   # shows the docstring
print(celsius_to_fahrenheit(100))   # 212.0
```

### Three Useful Functions

Let us build three genuinely useful functions:

```python
import math

def area_of_circle(radius):
    """Return the area of a circle with the given radius."""
    if radius < 0:
        return None   # invalid input
    return math.pi * radius ** 2

def is_even(number):
    """Return True if the number is even, False if odd."""
    return number % 2 == 0

def celsius_to_fahrenheit(celsius):
    """Convert Celsius to Fahrenheit."""
    return (celsius * 9 / 5) + 32

# Test them
print(area_of_circle(5))           # 78.53981...
print(f"{area_of_circle(5):.2f}")  # 78.54

print(is_even(4))    # True
print(is_even(7))    # False

print(celsius_to_fahrenheit(0))    # 32.0
print(celsius_to_fahrenheit(100))  # 212.0
print(celsius_to_fahrenheit(37))   # 98.6 (body temperature!)
```

### Functions Calling Functions

```python
def square(n):
    """Return n squared."""
    return n * n

def sum_of_squares(a, b):
    """Return the sum of the squares of a and b."""
    return square(a) + square(b)

print(sum_of_squares(3, 4))   # 9 + 16 = 25
```

### Early Return

A function can return early to avoid deep nesting:

```python
def get_grade(score):
    """Convert a numeric score to a letter grade."""
    if score < 0 or score > 100:
        return "Invalid score"
    if score >= 90:
        return "A"
    if score >= 80:
        return "B"
    if score >= 70:
        return "C"
    if score >= 60:
        return "D"
    return "F"

print(get_grade(88))   # B
print(get_grade(105))  # Invalid score
```

### Activity: Unit Converter

```python
def km_to_miles(km):
    """Convert kilometres to miles."""
    return km * 0.621371

def kg_to_pounds(kg):
    """Convert kilograms to pounds."""
    return kg * 2.20462

def litres_to_pints(litres):
    """Convert litres to pints."""
    return litres * 1.75975

print("=== UNIT CONVERTER ===")
print(f"10 km = {km_to_miles(10):.2f} miles")
print(f"70 kg = {kg_to_pounds(70):.1f} lbs")
print(f"1 litre = {litres_to_pints(1):.2f} pints")

# Interactive part
km = float(input("\nEnter kilometres: "))
print(f"{km} km = {km_to_miles(km):.2f} miles")
```

### Key Takeaways

- Define with `def name(parameters):`, call with `name(arguments)`
- Use `return` to send a value back to the caller
- Docstrings (`"""description"""`) document what a function does
- Functions can call other functions
- Return early to handle invalid input before main logic runs
- Write functions that do **one thing** — they are easier to test and reuse'),

('dev-l46', 'Python Parameters: Default, *args, **kwargs', 'developers', 'Python', 'en', 'intermediate', 40, 150, 46,
'## Python Parameters: Default, *args, **kwargs

Python gives you three powerful ways to make functions flexible: default parameter values, variable positional arguments (`*args`), and variable keyword arguments (`**kwargs`).

### Default Parameter Values

Default values are used when a caller does not provide that argument:

```python
def greet(name, greeting="Hello", punctuation="!"):
    print(f"{greeting}, {name}{punctuation}")

greet("Alice")                     # Hello, Alice!
greet("Bob", "Hi")                 # Hi, Bob!
greet("Carol", "Hey", ".")         # Hey, Carol.
greet("Dave", punctuation="...")   # Hello, Dave...
```

Default arguments must come **after** non-default arguments.

### Positional vs Keyword Arguments

```python
def describe_pet(name, animal, age):
    print(f"{name} is a {age}-year-old {animal}.")

# Positional (order matters)
describe_pet("Fluffy", "cat", 3)

# Keyword (order does not matter)
describe_pet(age=5, name="Rex", animal="dog")

# Mixed (positional first, then keyword)
describe_pet("Goldie", age=2, animal="fish")
```

### `*args` — Variable Positional Arguments

Use `*args` when you do not know how many positional arguments will be passed. Inside the function, `args` is a **tuple**:

```python
def add_all(*args):
    """Add any number of values together."""
    print(f"Arguments received: {args}")
    return sum(args)

print(add_all(1, 2))            # 3
print(add_all(1, 2, 3, 4, 5))  # 15
print(add_all(10, 20, 30))      # 60

def print_all(*items):
    for item in items:
        print("-", item)

print_all("apple", "banana", "cherry", "mango")
```

### `**kwargs` — Variable Keyword Arguments

Use `**kwargs` when you do not know how many keyword arguments will be passed. Inside the function, `kwargs` is a **dict**:

```python
def build_profile(**kwargs):
    """Build a profile from keyword arguments."""
    print("Profile:")
    for key, value in kwargs.items():
        print(f"  {key}: {value}")

build_profile(name="Alice", age=14, city="Dublin", hobby="coding")
```

Output:
```
Profile:
  name: Alice
  age: 14
  city: Dublin
  hobby: coding
```

### Combining All Parameter Types

The order must be: regular, `*args`, keyword-only, `**kwargs`

```python
def display(title, *items, separator="---", **metadata):
    print(f"\n{title}")
    print(separator)
    for item in items:
        print(f"  • {item}")
    if metadata:
        print("Extra info:")
        for k, v in metadata.items():
            print(f"  {k}: {v}")

display("Shopping List",
        "Milk", "Eggs", "Bread",
        separator="===",
        store="Tesco",
        budget=20)
```

### Unpacking with `*` and `**`

You can also use `*` and `**` when **calling** a function to unpack a list or dict:

```python
def add(a, b, c):
    return a + b + c

numbers = [1, 2, 3]
print(add(*numbers))   # same as add(1, 2, 3) → 6

info = {"a": 10, "b": 20, "c": 30}
print(add(**info))     # same as add(a=10, b=20, c=30) → 60
```

### Practical Example

```python
def make_html_tag(tag, *content, **attributes):
    """Build a simple HTML tag string."""
    attrs = ""
    for key, value in attributes.items():
        attrs += f'' {key}="{value}"''
    inner = " ".join(str(c) for c in content)
    return f"<{tag}{attrs}>{inner}</{tag}>"

print(make_html_tag("p", "Hello World"))
# <p>Hello World</p>

print(make_html_tag("a", "Click here", href="https://example.com", target="_blank"))
# <a href="https://example.com" target="_blank">Click here</a>

print(make_html_tag("ul", "item one", "item two", "item three", id="my-list"))
```

### Key Takeaways

- Default values: `def f(x, y=10):` — y is optional with fallback value
- `*args` collects extra positional arguments as a tuple
- `**kwargs` collects extra keyword arguments as a dictionary
- Order: `(regular, *args, keyword-only-defaults, **kwargs)`
- Unpack lists with `*list` and dicts with `**dict` when calling functions'),

('dev-l47', 'Python Return Values', 'developers', 'Python', 'en', 'intermediate', 35, 150, 47,
'## Python Return Values

The `return` statement sends a value back from a function to wherever it was called. Understanding return values well lets you write functions that genuinely produce useful results.

### Basic Return

```python
def double(n):
    return n * 2

result = double(5)
print(result)          # 10
print(double(7))       # 14
print(double(3) + 1)   # 7  — use it in expressions directly
```

### Returning None

A function that has no `return` statement (or just `return` with no value) returns `None`:

```python
def say_hi():
    print("Hi!")

result = say_hi()   # prints "Hi!"
print(result)       # None

# Explicit return None is the same
def nothing():
    return None
```

Use `None` as a sentinel value to signal "no result":

```python
def find_student(name, students):
    """Return student dict or None if not found."""
    for student in students:
        if student["name"] == name:
            return student
    return None   # not found

roster = [
    {"name": "Alice", "grade": "A"},
    {"name": "Bob", "grade": "B"}
]

result = find_student("Alice", roster)
if result is not None:
    print(f"Found: {result}")
else:
    print("Student not found")
```

### Returning Multiple Values

Python functions can return multiple values as a tuple:

```python
def min_max_avg(numbers):
    """Return the minimum, maximum and average of a list."""
    low = min(numbers)
    high = max(numbers)
    avg = sum(numbers) / len(numbers)
    return low, high, avg   # returns a tuple (low, high, avg)

scores = [72, 88, 95, 61, 80]
minimum, maximum, average = min_max_avg(scores)
print(f"Min: {minimum}, Max: {maximum}, Average: {average:.1f}")
# Min: 61, Max: 95, Average: 79.2
```

### Early Return for Validation

Use early returns to handle bad input before reaching the main logic:

```python
def safe_divide(a, b):
    """Divide a by b, returning None if b is zero."""
    if b == 0:
        print("Error: cannot divide by zero!")
        return None
    return a / b

print(safe_divide(10, 2))   # 5.0
print(safe_divide(10, 0))   # Error message, then None
```

### Returning Different Types Conditionally

```python
def describe_number(n):
    """Return a description of a number."""
    if n == 0:
        return "zero"
    elif n > 0:
        return "positive"
    else:
        return "negative"

for num in [-3, 0, 7]:
    print(f"{num} is {describe_number(num)}")
```

### Functions That Return Functions (Preview)

```python
def make_multiplier(factor):
    """Return a function that multiplies by factor."""
    def multiply(n):
        return n * factor
    return multiply   # returning the function itself!

double = make_multiplier(2)
triple = make_multiplier(3)

print(double(5))   # 10
print(triple(5))   # 15
print(double(triple(4)))   # 24
```

### Activity: Statistics Calculator

```python
def statistics(data):
    """Return a dictionary of statistics for a list of numbers."""
    if not data:
        return None

    n = len(data)
    total = sum(data)
    mean = total / n

    sorted_data = sorted(data)
    mid = n // 2
    if n % 2 == 0:
        median = (sorted_data[mid - 1] + sorted_data[mid]) / 2
    else:
        median = sorted_data[mid]

    return {
        "count": n,
        "sum": total,
        "mean": round(mean, 2),
        "median": median,
        "min": min(data),
        "max": max(data),
        "range": max(data) - min(data)
    }

scores = [72, 88, 95, 61, 80, 73, 91, 67]
stats = statistics(scores)

if stats:
    for key, value in stats.items():
        print(f"  {key:8}: {value}")
```

### Key Takeaways

- `return value` sends data back to the caller
- Functions without `return` (or with bare `return`) return `None`
- Return multiple values as a tuple: `return a, b, c` — unpack with `x, y, z = f()`
- Use early returns to validate input before the main logic
- The return value can be used in expressions, stored in variables, or passed to other functions'),

('dev-l48', 'Python Scope: LEGB Rule', 'developers', 'Python', 'en', 'intermediate', 35, 150, 48,
'## Python Scope: The LEGB Rule

**Scope** determines where a variable can be seen and used. Python searches for a variable in four places, in order: **L**ocal → **E**nclosing → **G**lobal → **B**uilt-in. This is called the **LEGB rule**.

### Local Scope

Variables created inside a function exist only inside that function:

```python
def my_function():
    x = 10   # local variable
    print(x)

my_function()   # 10
# print(x)      # NameError! x doesn''t exist outside the function
```

### Global Scope

Variables created at the top level (outside any function) are global:

```python
message = "Hello from global scope!"   # global variable

def show_message():
    print(message)   # can READ a global variable

show_message()     # Hello from global scope!
print(message)     # Hello from global scope!
```

### Local vs Global — Same Name

When a local and global variable share the same name, the local one wins inside the function:

```python
colour = "blue"   # global

def change_colour():
    colour = "red"   # LOCAL variable — does NOT change global
    print(colour)    # red

change_colour()    # red
print(colour)      # blue — global is unchanged!
```

### The `global` Keyword

If you truly need to modify a global variable inside a function, use `global`:

```python
count = 0   # global

def increment():
    global count   # tell Python: use the global, not a new local
    count += 1

increment()
increment()
increment()
print(count)   # 3
```

**Why to avoid `global`:** Using global variables makes functions hard to test and unpredictable. Pass data in via parameters and return it instead:

```python
# Bad practice:
total = 0
def add_to_total(n):
    global total
    total += n

# Good practice:
def add(current_total, n):
    return current_total + n

total = 0
total = add(total, 5)
total = add(total, 3)
print(total)   # 8
```

### Enclosing Scope

When functions are nested, the inner function can access the outer function''s variables:

```python
def outer():
    x = "outer value"

    def inner():
        print(x)   # x from the ENCLOSING scope

    inner()

outer()   # outer value
```

### Built-in Scope

Python has many built-in names like `print`, `len`, `range`, `int`, `str`. These live in the built-in scope and are always available. Avoid naming your variables the same as built-ins:

```python
# DO NOT do this:
list = [1, 2, 3]    # you just shadowed the built-in list()!
# list("hello")     # now broken!

# Use descriptive names instead:
number_list = [1, 2, 3]
```

### Full LEGB Example

```python
x = "global"

def outer():
    x = "enclosing"

    def inner():
        x = "local"
        print(x)   # local (L wins)

    inner()
    print(x)       # enclosing (L is gone, E wins)

outer()
print(x)           # global (L and E are gone, G wins)
```

### `nonlocal` Keyword

Like `global` but for the enclosing scope:

```python
def make_counter():
    count = 0
    def increment():
        nonlocal count
        count += 1
        return count
    return increment

counter = make_counter()
print(counter())   # 1
print(counter())   # 2
print(counter())   # 3
```

### Key Takeaways

- **LEGB**: Python looks up names in Local → Enclosing → Global → Built-in order
- Local variables exist only inside their function
- Functions can read global variables but cannot reassign them without `global`
- Avoid `global` — pass data in as parameters and return results instead
- Never shadow built-in names like `list`, `dict`, `input`, `print`'),

('dev-l49', 'Python String Formatting', 'developers', 'Python', 'en', 'intermediate', 35, 150, 49,
'## Python String Formatting

Python gives you several ways to build strings from variables. The modern way is **f-strings**, but you will also encounter the older styles in real-world code.

### Method 1: String Concatenation (old, clunky)

```python
name = "Alice"
age = 14

# This works but is messy and error-prone
message = "Hello, " + name + "! You are " + str(age) + " years old."
print(message)
```

### Method 2: % Formatting (old style)

```python
name = "Alice"
age = 14
score = 95.678

print("Hello, %s!" % name)                # Hello, Alice!
print("Age: %d" % age)                    # Age: 14
print("Score: %.2f" % score)              # Score: 95.68
print("%s scored %d (%.1f%%)" % (name, age, score))
```

### Method 3: `.format()` (Python 3, still common)

```python
name = "Bob"
score = 87.5

print("Hello, {}!".format(name))
print("Score: {:.1f}".format(score))
print("{0} scored {1:.0f} out of 100".format(name, score))

# Named placeholders
print("{name} is {age} years old".format(name="Carol", age=13))
```

### Method 4: f-strings (modern, recommended)

F-strings start with `f` before the quote and embed expressions in `{}`:

```python
name = "Dave"
age = 15
score = 92.456

print(f"Hello, {name}!")                       # Hello, Dave!
print(f"Age: {age}")                           # Age: 15
print(f"Score: {score:.2f}")                   # Score: 92.46
print(f"Score: {score:.0f}%")                  # Score: 92%
print(f"Name uppercase: {name.upper()}")       # DAVE
print(f"Age in 10 years: {age + 10}")         # 25
```

### Format Specification Mini-Language

The part after `:` controls how values are displayed:

```python
pi = 3.14159265

print(f"{pi:.2f}")    # 3.14  — 2 decimal places
print(f"{pi:.4f}")    # 3.1416 — 4 decimal places
print(f"{pi:10.2f}")  #       3.14 — 10 chars wide, right-aligned
print(f"{pi:<10.2f}") # 3.14       — left-aligned
print(f"{pi:^10.2f}") #    3.14    — centre-aligned

n = 42
print(f"{n:05d}")     # 00042 — pad with zeros, width 5
print(f"{n:+d}")      # +42   — always show sign
print(f"{n:b}")       # 101010 — binary
print(f"{n:x}")       # 2a    — hexadecimal

# Thousands separator
big = 1234567
print(f"{big:,}")     # 1,234,567
print(f"{big:_}")     # 1_234_567
```

### Multi-line Strings

```python
poem = """Roses are red,
Violets are blue,
Python is great,
And so are you!"""
print(poem)

# f-strings work with multi-line too
name = "Alex"
report = f"""
Student Report
==============
Name:  {name}
Score: {95:.1f}%
Grade: A
"""
print(report)
```

### Activity: Format a Receipt

```python
def print_receipt(items, tax_rate=0.20):
    """Print a formatted shop receipt."""
    print("=" * 35)
    print(f"{'CODESHIP STORE':^35}")
    print("=" * 35)
    print(f"{'ITEM':<20} {'PRICE':>10}")
    print("-" * 35)

    subtotal = 0
    for item, price in items:
        print(f"{item:<20} £{price:>8.2f}")
        subtotal += price

    tax = subtotal * tax_rate
    total = subtotal + tax

    print("-" * 35)
    print(f"{'Subtotal':<20} £{subtotal:>8.2f}")
    print(f"{'VAT (20%)':<20} £{tax:>8.2f}")
    print("=" * 35)
    print(f"{'TOTAL':<20} £{total:>8.2f}")
    print("=" * 35)

purchases = [
    ("Python Book", 24.99),
    ("USB Cable", 8.50),
    ("Notepad", 3.25),
    ("Sticky Notes", 2.99)
]

print_receipt(purchases)
```

### Key Takeaways

- f-strings (`f"Hello {name}"`) are the modern, preferred way to format strings
- Format spec after `:` controls width, alignment, decimal places, padding
- `:.2f` — 2 decimal places; `:10` — minimum width 10; `:<` left, `:>` right, `:^` centre
- `:,` adds thousands separators; `:05d` pads with zeros
- Multi-line strings use triple quotes `"""..."""` or `'"'"''"'"''"'"'...'"'"''"'"''"'"'`')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO public.lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES

('dev-l50', 'Python Reading Files', 'developers', 'Python', 'en', 'intermediate', 40, 150, 50,
'## Python Reading Files

Almost every real program reads data from files — configuration settings, user data, CSV spreadsheets, logs. Python makes file reading straightforward with the built-in `open()` function.

### The `open()` Function

```python
file = open("hello.txt", "r")   # "r" = read mode
content = file.read()
file.close()                     # IMPORTANT: always close!
print(content)
```

The `"r"` mode means read-only. The file must already exist.

### The `with` Statement (Best Practice)

The `with` statement automatically closes the file even if an error occurs:

```python
with open("hello.txt", "r") as file:
    content = file.read()
    print(content)
# file is automatically closed here — no need for file.close()
```

Always use `with` — it is safer and cleaner.

### Reading the Whole File

```python
with open("story.txt", "r") as f:
    content = f.read()      # read entire file as one string
    print(content)
    print(f"Total characters: {len(content)}")
```

### Reading Line by Line

```python
# readline() — one line at a time
with open("poem.txt", "r") as f:
    line1 = f.readline()   # reads first line including \n
    line2 = f.readline()   # reads second line
    print(line1.strip())   # strip() removes the newline
    print(line2.strip())

# readlines() — all lines as a list
with open("poem.txt", "r") as f:
    lines = f.readlines()   # [''line1\n'', ''line2\n'', ...]
    print(f"The file has {len(lines)} lines")

    for i, line in enumerate(lines, 1):
        print(f"{i}: {line.strip()}")

# Best way: iterate directly
with open("poem.txt", "r") as f:
    for line in f:            # memory-efficient for large files
        print(line.strip())
```

### Handling Missing Files

```python
try:
    with open("data.txt", "r") as f:
        content = f.read()
except FileNotFoundError:
    print("Error: file not found!")
    content = ""
```

### Reading a CSV File Manually

CSV (Comma Separated Values) is one of the most common data formats:

```python
# grades.csv contains:
# Alice,88,A
# Bob,75,B
# Carol,92,A

students = []

with open("grades.csv", "r") as f:
    for line in f:
        line = line.strip()
        if line:   # skip empty lines
            parts = line.split(",")
            name = parts[0]
            score = int(parts[1])
            grade = parts[2]
            students.append({"name": name, "score": score, "grade": grade})

for student in students:
    print(f"{student[''name'']}: {student[''score'']} ({student[''grade'']})")

# Statistics
scores = [s["score"] for s in students]
print(f"\nAverage: {sum(scores)/len(scores):.1f}")
print(f"Highest: {max(scores)}")
```

### Using the `csv` Module

Python has a built-in `csv` module that handles edge cases automatically:

```python
import csv

with open("grades.csv", "r") as f:
    reader = csv.reader(f)
    for row in reader:
        name, score, grade = row
        print(f"{name}: {score}")
```

### Reading with `pathlib` (Modern Approach)

```python
from pathlib import Path

# Simple one-liner to read a whole file
text = Path("hello.txt").read_text()
print(text)

# Check if a file exists before reading
file_path = Path("data.txt")
if file_path.exists():
    content = file_path.read_text()
else:
    print("File does not exist")
```

### Activity: Word Counter

```python
def analyse_text_file(filename):
    """Read a text file and return statistics."""
    try:
        with open(filename, "r") as f:
            content = f.read()
    except FileNotFoundError:
        return None

    lines = content.splitlines()
    words = content.split()
    chars = len(content)
    chars_no_spaces = len(content.replace(" ", "").replace("\n", ""))

    # Word frequency
    word_freq = {}
    for word in words:
        word = word.lower().strip(".,!?;:\"''")
        if word:
            word_freq[word] = word_freq.get(word, 0) + 1

    top_words = sorted(word_freq.items(), key=lambda x: x[1], reverse=True)[:5]

    return {
        "lines": len(lines),
        "words": len(words),
        "characters": chars,
        "chars_no_spaces": chars_no_spaces,
        "top_words": top_words
    }

result = analyse_text_file("my_essay.txt")
if result:
    print(f"Lines: {result[''lines'']}")
    print(f"Words: {result[''words'']}")
    print(f"Characters: {result[''characters'']}")
    print("Top words:")
    for word, count in result["top_words"]:
        print(f"  {word!r}: {count} times")
```

### Key Takeaways

- `open(filename, "r")` opens a file for reading
- Always use `with open(...) as f:` — it closes the file automatically
- `f.read()` reads the whole file; `f.readlines()` returns a list; `for line in f:` iterates line by line
- Use `try/except FileNotFoundError` to handle missing files gracefully
- The `csv` module handles CSV files better than manual `split(",")`)
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO public.lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES

('dev-l51', 'Python Writing Files', 'developers', 'Python', 'en', 'intermediate', 40, 150, 51,
'## Python Writing Files

Writing to files lets your programs save data that persists after the program ends. You can create new files, overwrite existing ones, or append to them.

### Write Mode: `"w"`

`"w"` creates the file if it does not exist, or **completely overwrites** it if it does:

```python
with open("greeting.txt", "w") as f:
    f.write("Hello, World!\n")
    f.write("This is my first file.\n")
    f.write("Python makes file writing easy.\n")

print("File written!")
```

After running this, `greeting.txt` will contain those three lines.

### Append Mode: `"a"`

`"a"` adds to the end of an existing file without deleting anything:

```python
with open("log.txt", "a") as f:
    f.write("New log entry added.\n")
```

Each time you run this, a new line is added to `log.txt`.

### `write()` vs `writelines()`

```python
# write() — writes a single string
with open("numbers.txt", "w") as f:
    f.write("One\n")
    f.write("Two\n")
    f.write("Three\n")

# writelines() — writes a list of strings (you supply the newlines)
lines = ["Monday\n", "Tuesday\n", "Wednesday\n"]
with open("days.txt", "w") as f:
    f.writelines(lines)

# Using a loop with join (clean pattern)
items = ["apple", "banana", "cherry"]
with open("fruits.txt", "w") as f:
    f.write("\n".join(items))
```

### Using `pathlib` to Write Files

```python
from pathlib import Path

# Simple one-liner
Path("hello.txt").write_text("Hello from pathlib!")

# Read back
text = Path("hello.txt").read_text()
print(text)   # Hello from pathlib!
```

### Writing CSV Files

```python
import csv

students = [
    ["Alice", 88, "A"],
    ["Bob", 75, "B"],
    ["Carol", 92, "A"]
]

with open("students.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["Name", "Score", "Grade"])  # header
    writer.writerows(students)                   # all data rows

print("CSV saved!")
```

### Activity: Simple Diary App

```python
from datetime import datetime
from pathlib import Path

DIARY_FILE = "diary.txt"

def add_entry(text):
    """Add a diary entry with timestamp."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    entry = f"[{timestamp}] {text}\n"
    with open(DIARY_FILE, "a") as f:
        f.write(entry)
    print("Entry saved!")

def view_entries():
    """Display all diary entries."""
    if not Path(DIARY_FILE).exists():
        print("No diary entries yet.")
        return
    with open(DIARY_FILE, "r") as f:
        content = f.read()
    if content:
        print("\n=== MY DIARY ===")
        print(content)
    else:
        print("Diary is empty.")

def clear_diary():
    """Delete all diary entries."""
    confirm = input("Delete all entries? (yes/no): ")
    if confirm.lower() == "yes":
        Path(DIARY_FILE).write_text("")
        print("Diary cleared.")

print("=== DIARY APP ===")
print("Commands: write, read, clear, quit")

while True:
    cmd = input("\n> ").lower().strip()
    if cmd == "write":
        entry = input("Write your entry: ")
        add_entry(entry)
    elif cmd == "read":
        view_entries()
    elif cmd == "clear":
        clear_diary()
    elif cmd == "quit":
        print("Goodbye!")
        break
    else:
        print("Unknown command. Try: write, read, clear, quit")
```

### Working with JSON Files

JSON is a popular format for saving structured data:

```python
import json

# Write a Python dict/list to JSON
data = {
    "player": "Alex",
    "score": 1500,
    "level": 5,
    "inventory": ["sword", "shield", "potion"]
}

with open("save_game.json", "w") as f:
    json.dump(data, f, indent=2)   # indent=2 makes it pretty

# Read it back
with open("save_game.json", "r") as f:
    loaded = json.load(f)

print(loaded["player"])    # Alex
print(loaded["inventory"]) # [''sword'', ''shield'', ''potion'']
```

### Key Takeaways

- `"w"` mode creates/overwrites; `"a"` mode appends
- `f.write(string)` writes a string; remember to add `"\n"` for newlines
- `f.writelines(list)` writes a list of strings
- `pathlib.Path("file.txt").write_text(content)` is the modern one-liner approach
- Use `json.dump()` and `json.load()` to save and load structured data as JSON'),

('dev-l52', 'Python Error Handling', 'developers', 'Python', 'en', 'intermediate', 40, 150, 52,
'## Python Error Handling

Programs encounter unexpected situations — a file that does not exist, invalid user input, a network connection that fails. Error handling lets your program deal with these gracefully instead of crashing.

### What is an Exception?

When Python encounters an error at runtime, it raises an **exception** — an object that describes what went wrong:

```python
print(10 / 0)            # ZeroDivisionError
int("hello")             # ValueError
open("missing.txt")      # FileNotFoundError
my_list = [1, 2, 3]
print(my_list[10])       # IndexError
my_dict = {}
print(my_dict["key"])    # KeyError
```

Without error handling, any of these would crash your program.

### `try` / `except`

Wrap risky code in a `try` block. If an error occurs, the `except` block runs:

```python
try:
    number = int(input("Enter a number: "))
    result = 100 / number
    print(f"100 / {number} = {result}")
except:
    print("Something went wrong!")
```

### Catching Specific Exceptions

Always catch the specific type of error you expect — never use a bare `except:` in real code:

```python
try:
    number = int(input("Enter a number: "))
    result = 100 / number
    print(f"Result: {result}")
except ValueError:
    print("That''s not a valid number!")
except ZeroDivisionError:
    print("Cannot divide by zero!")
```

### Multiple Except Clauses

```python
def safe_file_read(filename):
    try:
        with open(filename, "r") as f:
            return f.read()
    except FileNotFoundError:
        print(f"Error: ''{filename}'' does not exist.")
    except PermissionError:
        print(f"Error: no permission to read ''{filename}''.")
    except OSError as e:
        print(f"OS error: {e}")
    return None
```

### The `else` Clause

The `else` block runs only if **no exception** was raised:

```python
try:
    number = int(input("Enter a positive number: "))
except ValueError:
    print("That''s not a number!")
else:
    # Only runs if int() succeeded
    if number > 0:
        print(f"Great! {number} is positive.")
    else:
        print("That''s not positive!")
```

### The `finally` Clause

`finally` always runs, whether an exception occurred or not — great for cleanup:

```python
def process_file(filename):
    f = None
    try:
        f = open(filename, "r")
        data = f.read()
        return data
    except FileNotFoundError:
        print("File not found!")
        return None
    finally:
        if f:
            f.close()   # always close the file!
        print("process_file() finished.")
```

(In practice, use `with open(...)` instead — it handles this automatically.)

### `raise` — Triggering Your Own Exceptions

```python
def set_age(age):
    if not isinstance(age, int):
        raise TypeError("Age must be an integer")
    if age < 0 or age > 150:
        raise ValueError(f"Age {age} is not realistic")
    return age

try:
    set_age(-5)
except ValueError as e:
    print(f"Error: {e}")   # Error: Age -5 is not realistic
```

### Common Exception Types

| Exception | When it occurs |
|-----------|---------------|
| `ValueError` | Wrong type of value (e.g. `int("abc")`) |
| `TypeError` | Wrong type altogether |
| `ZeroDivisionError` | Division by zero |
| `FileNotFoundError` | File does not exist |
| `IndexError` | List index out of range |
| `KeyError` | Dictionary key not found |
| `AttributeError` | Object has no such attribute |
| `ImportError` | Module not found |

### Activity: Robust Input Handler

```python
def get_integer(prompt, min_val=None, max_val=None):
    """Keep asking until the user enters a valid integer in range."""
    while True:
        try:
            value = int(input(prompt))
        except ValueError:
            print("  Please enter a whole number.")
            continue

        if min_val is not None and value < min_val:
            print(f"  Must be at least {min_val}.")
        elif max_val is not None and value > max_val:
            print(f"  Must be at most {max_val}.")
        else:
            return value

age = get_integer("Enter your age: ", min_val=1, max_val=120)
score = get_integer("Enter a score (0-100): ", min_val=0, max_val=100)
print(f"Age: {age}, Score: {score}")
```

### Key Takeaways

- `try/except` catches exceptions before they crash your program
- Always catch **specific** exception types, not bare `except:`
- `else` runs when no exception occurred; `finally` always runs
- Use `raise` to trigger exceptions in your own functions for invalid input
- Common types: `ValueError`, `TypeError`, `FileNotFoundError`, `IndexError`, `KeyError`'),

('dev-l53', 'Python Classes and Objects', 'developers', 'Python', 'en', 'intermediate', 45, 150, 53,
'## Python Classes and Objects

**Object-Oriented Programming (OOP)** is a way of organising code by grouping related data and functions together into **classes**. A class is a blueprint; an **object** is an instance built from that blueprint.

### Why Use Classes?

Without classes, a bank account might look like this:

```python
account_owner = "Alice"
account_balance = 500
account_number = "ACC001"

def deposit(amount):
    global account_balance
    account_balance += amount
```

This gets messy with multiple accounts. With a class, each account is self-contained.

### Defining a Class

```python
class BankAccount:
    """A simple bank account."""

    def __init__(self, owner, balance=0):
        """Initialise the account. Called when you create an object."""
        self.owner = owner         # instance attribute
        self.balance = balance     # instance attribute
        self.transactions = []     # instance attribute

    def deposit(self, amount):
        """Add money to the account."""
        if amount <= 0:
            print("Deposit amount must be positive.")
            return
        self.balance += amount
        self.transactions.append(f"+£{amount:.2f}")
        print(f"Deposited £{amount:.2f}. New balance: £{self.balance:.2f}")

    def withdraw(self, amount):
        """Remove money from the account."""
        if amount <= 0:
            print("Withdrawal amount must be positive.")
            return
        if amount > self.balance:
            print("Insufficient funds!")
            return
        self.balance -= amount
        self.transactions.append(f"-£{amount:.2f}")
        print(f"Withdrew £{amount:.2f}. New balance: £{self.balance:.2f}")

    def get_statement(self):
        """Print a mini statement."""
        print(f"\nAccount: {self.owner}")
        print(f"Balance: £{self.balance:.2f}")
        if self.transactions:
            print("Last transactions:")
            for t in self.transactions[-5:]:
                print(f"  {t}")
        else:
            print("No transactions yet.")
```

### Creating Objects (Instances)

```python
# Create two separate accounts
alice = BankAccount("Alice", 1000)
bob = BankAccount("Bob", 250)

# Each object has its own data
alice.deposit(500)     # Alice deposits 500
bob.deposit(100)       # Bob deposits 100
alice.withdraw(200)    # Alice withdraws 200

alice.get_statement()
bob.get_statement()

print(alice.balance)   # 1300
print(bob.balance)     # 350
```

### Understanding `self`

`self` refers to the **current object**. When you call `alice.deposit(500)`, Python automatically passes `alice` as `self` — so `self.balance` means Alice''s balance, not Bob''s.

### Adding More Methods

```python
class BankAccount:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount):
        self.balance += amount

    def withdraw(self, amount):
        if amount > self.balance:
            return False
        self.balance -= amount
        return True

    def transfer(self, other_account, amount):
        """Transfer money to another account."""
        if self.withdraw(amount):
            other_account.deposit(amount)
            print(f"Transferred £{amount} from {self.owner} to {other_account.owner}")
        else:
            print("Transfer failed: insufficient funds")

    def __str__(self):
        """String representation for print()."""
        return f"BankAccount({self.owner}, £{self.balance:.2f})"

alice = BankAccount("Alice", 1000)
bob = BankAccount("Bob", 200)

alice.transfer(bob, 300)
print(alice)   # BankAccount(Alice, £700.00)
print(bob)     # BankAccount(Bob, £500.00)
```

### Class vs Instance

```python
class Student:
    school = "CODEship Academy"   # CLASS attribute — shared by all

    def __init__(self, name, grade):
        self.name = name     # INSTANCE attribute — unique to each object
        self.grade = grade

alice = Student("Alice", "A")
bob = Student("Bob", "B")

print(alice.school)    # CODEship Academy
print(bob.school)      # CODEship Academy (same!)
print(Student.school)  # CODEship Academy

print(alice.name)      # Alice
print(bob.name)        # Bob (different!)
```

### Key Takeaways

- `class Name:` defines a blueprint; `Name()` creates an object (instance)
- `__init__` runs automatically when an object is created — use it to set up attributes
- `self` refers to the current object and must be the first parameter of every method
- Instance attributes (`self.x`) are unique per object; class attributes are shared
- `__str__` defines what `print(object)` displays'),

('dev-l54', 'Python Inheritance', 'developers', 'Python', 'en', 'intermediate', 40, 150, 54,
'## Python Inheritance

Inheritance lets one class **inherit** the attributes and methods of another, allowing you to reuse code and model real-world relationships like "a Dog IS-A Animal."

### The Base Class

```python
class Animal:
    """A generic animal."""

    def __init__(self, name, age):
        self.name = name
        self.age = age
        self.is_alive = True

    def eat(self):
        print(f"{self.name} is eating.")

    def sleep(self):
        print(f"{self.name} is sleeping. Zzz...")

    def describe(self):
        print(f"{self.name} is {self.age} years old.")

    def __str__(self):
        return f"{type(self).__name__}(name={self.name}, age={self.age})"
```

### Child Classes

A child class inherits everything from the parent and can add or override methods:

```python
class Dog(Animal):
    """A dog — inherits from Animal."""

    def __init__(self, name, age, breed):
        super().__init__(name, age)   # call Animal.__init__
        self.breed = breed            # add dog-specific attribute

    def bark(self):
        print(f"{self.name} says: Woof!")

    def fetch(self, item):
        print(f"{self.name} fetches the {item}!")

    def describe(self):           # OVERRIDE the parent method
        super().describe()        # still call the parent version
        print(f"  Breed: {self.breed}")


class Cat(Animal):
    """A cat — inherits from Animal."""

    def __init__(self, name, age, indoor=True):
        super().__init__(name, age)
        self.indoor = indoor

    def meow(self):
        print(f"{self.name} says: Meow!")

    def purr(self):
        print(f"{self.name} is purring... purrr")

    def describe(self):
        super().describe()
        location = "indoor" if self.indoor else "outdoor"
        print(f"  Type: {location} cat")
```

### Using the Classes

```python
rex = Dog("Rex", 3, "Labrador")
whiskers = Cat("Whiskers", 5, indoor=True)

# Inherited methods
rex.eat()        # Rex is eating.
whiskers.sleep() # Whiskers is sleeping. Zzz...

# Dog-specific methods
rex.bark()       # Rex says: Woof!
rex.fetch("ball") # Rex fetches the ball!

# Cat-specific methods
whiskers.meow()  # Whiskers says: Meow!
whiskers.purr()  # Whiskers is purring... purrr

# Overridden describe()
rex.describe()
# Rex is 3 years old.
#   Breed: Labrador

print(rex)       # Dog(name=Rex, age=3)
print(whiskers)  # Cat(name=Whiskers, age=5)
```

### `super()` Explained

`super()` gives you access to the parent class. It is most commonly used in `__init__` to call the parent''s initialiser:

```python
class Vehicle:
    def __init__(self, make, speed):
        self.make = make
        self.speed = speed

class Car(Vehicle):
    def __init__(self, make, speed, doors):
        super().__init__(make, speed)  # initialise parent
        self.doors = doors             # add car-specific attribute

class ElectricCar(Car):
    def __init__(self, make, speed, doors, battery_kwh):
        super().__init__(make, speed, doors)
        self.battery_kwh = battery_kwh

tesla = ElectricCar("Tesla", 250, 4, 100)
print(tesla.make)        # Tesla
print(tesla.battery_kwh) # 100
```

### `isinstance()` and `issubclass()`

```python
rex = Dog("Rex", 3, "Labrador")

print(isinstance(rex, Dog))     # True
print(isinstance(rex, Animal))  # True — Dog IS-A Animal!
print(isinstance(rex, Cat))     # False

print(issubclass(Dog, Animal))  # True
print(issubclass(Cat, Animal))  # True
print(issubclass(Dog, Cat))     # False
```

### Polymorphism — Same Method, Different Behaviour

```python
animals = [
    Dog("Rex", 3, "Labrador"),
    Cat("Luna", 2, indoor=True),
    Dog("Buddy", 5, "Poodle")
]

for animal in animals:
    animal.describe()   # each calls ITS OWN version of describe()
    print()
```

### Activity: Shape Hierarchy

```python
import math

class Shape:
    def area(self):
        return 0
    def perimeter(self):
        return 0
    def describe(self):
        print(f"{type(self).__name__}: area={self.area():.2f}, perimeter={self.perimeter():.2f}")

class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius
    def area(self):
        return math.pi * self.radius ** 2
    def perimeter(self):
        return 2 * math.pi * self.radius

class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height
    def area(self):
        return self.width * self.height
    def perimeter(self):
        return 2 * (self.width + self.height)

shapes = [Circle(5), Rectangle(4, 6), Circle(3)]
for shape in shapes:
    shape.describe()
```

### Key Takeaways

- `class Child(Parent):` creates a child class that inherits all parent code
- `super().__init__(...)` calls the parent''s `__init__` — always do this in child `__init__`
- Override a method by defining it again in the child class
- `isinstance(obj, Class)` checks if an object is an instance of a class (or any parent)
- Polymorphism: different classes can define the same method name with different behaviour'),

('dev-l55', 'Python Modules: import and from', 'developers', 'Python', 'en', 'intermediate', 35, 150, 55,
'## Python Modules: import and from

A **module** is a Python file containing functions, classes, and variables that you can reuse. Python''s standard library has hundreds of modules, and you can create your own.

### Importing a Module

```python
import math

print(math.pi)          # 3.141592653589793
print(math.sqrt(16))    # 4.0
print(math.floor(3.7))  # 3
```

With `import math`, everything from math is accessed as `math.something`.

### `from ... import`

Import specific names directly so you do not need the module prefix:

```python
from math import pi, sqrt, floor

print(pi)         # 3.141592653589793
print(sqrt(25))   # 5.0
print(floor(3.9)) # 3
```

### `import ... as` (Alias)

Give a module or name a shorter alias:

```python
import random as r
from datetime import datetime as dt

print(r.randint(1, 10))
print(dt.now())
```

### The Standard Library — Useful Modules

```python
# random — generate random numbers
import random
print(random.randint(1, 100))
print(random.choice(["rock", "paper", "scissors"]))
numbers = [1, 2, 3, 4, 5]
random.shuffle(numbers)
print(numbers)

# datetime — dates and times
from datetime import datetime, date
now = datetime.now()
print(now.strftime("%Y-%m-%d %H:%M"))  # 2024-11-15 14:30
today = date.today()
print(today)

# os — operating system interaction
import os
print(os.getcwd())           # current directory
print(os.listdir("."))       # list files in current dir

# sys — system information
import sys
print(sys.version)           # Python version
print(sys.platform)          # ''linux'', ''win32'', ''darwin''

# time — timing and sleeping
import time
start = time.time()
# ... do something ...
end = time.time()
print(f"Took {end - start:.3f} seconds")
```

### Creating Your Own Module

Save this as `mytools.py`:

```python
# mytools.py

def greet(name):
    """Return a greeting string."""
    return f"Hello, {name}!"

def is_palindrome(text):
    """Return True if text reads the same forwards and backwards."""
    clean = text.lower().replace(" ", "")
    return clean == clean[::-1]

PI = 3.14159
```

Then use it in another file in the same folder:

```python
# main.py
import mytools

print(mytools.greet("Alice"))           # Hello, Alice!
print(mytools.is_palindrome("racecar")) # True
print(mytools.is_palindrome("hello"))   # False
print(mytools.PI)                       # 3.14159

# Or with from:
from mytools import greet, is_palindrome
print(greet("Bob"))
```

### The `__name__ == "__main__"` Pattern

When Python runs a file directly, `__name__` is `"__main__"`. When it is imported, `__name__` is the module name. This lets you include test code that only runs when the file is executed directly:

```python
# mytools.py

def add(a, b):
    return a + b

def multiply(a, b):
    return a * b

if __name__ == "__main__":
    # This only runs when you execute mytools.py directly
    # NOT when you import it
    print("Testing mytools...")
    print(add(2, 3))       # 5
    print(multiply(4, 5))  # 20
    print("All tests passed!")
```

### Package Structure (Preview)

A **package** is a folder of modules with an `__init__.py` file:

```
my_project/
    main.py
    utils/
        __init__.py
        maths.py
        strings.py
```

```python
# From main.py:
from utils.maths import add
from utils.strings import greet
```

### Key Takeaways

- `import module` imports everything, accessed as `module.name`
- `from module import name` imports specific names directly
- `import module as alias` creates a shorter name
- Python''s standard library has modules for maths, random, dates, files, and much more
- Create your own module by saving functions in a `.py` file
- Use `if __name__ == "__main__":` to write code that only runs when the file is executed directly'),

('dev-l56', 'Python pip and Popular Libraries', 'developers', 'Python', 'en', 'intermediate', 40, 150, 56,
'## Python pip and Popular Libraries

Python''s standard library is powerful, but the real magic happens with third-party libraries. `pip` is Python''s package manager — it downloads and installs libraries from the internet in seconds.

### What is pip?

`pip` stands for "Pip Installs Packages." It connects to the **Python Package Index (PyPI)** at pypi.org, which hosts over 500,000 packages.

### Using pip

Open your terminal and run these commands (outside Python, not inside the interpreter):

```bash
# Check pip is installed
pip --version
# or
pip3 --version

# Install a package
pip install requests

# Install a specific version
pip install requests==2.31.0

# Upgrade a package
pip install --upgrade requests

# List installed packages
pip list

# Uninstall a package
pip uninstall requests
```

### The `requests` Library

`requests` makes HTTP requests (fetching web pages and APIs) simple:

```bash
pip install requests
```

```python
import requests

# Fetch data from a free API
response = requests.get("https://api.agify.io?name=michael")

# Check it worked
print(response.status_code)   # 200 means success

# Parse the JSON data
data = response.json()
print(data)
# {''count'': 233482, ''name'': ''michael'', ''age'': 38}

print(f"The predicted age for Michael is: {data[''age'']}")
```

### Fetching a Real API

```python
import requests

def get_joke():
    """Fetch a random programming joke."""
    url = "https://official-joke-api.appspot.com/jokes/programming/random"
    response = requests.get(url)
    if response.status_code == 200:
        joke = response.json()[0]
        print(f"Setup: {joke[''setup'']}")
        print(f"Punchline: {joke[''punchline'']}")
    else:
        print("Could not fetch joke.")

get_joke()
```

### Error Handling with requests

```python
import requests

def fetch_data(url):
    try:
        response = requests.get(url, timeout=5)
        response.raise_for_status()   # raises error for 4xx/5xx status
        return response.json()
    except requests.exceptions.ConnectionError:
        print("No internet connection!")
    except requests.exceptions.Timeout:
        print("Request timed out!")
    except requests.exceptions.HTTPError as e:
        print(f"HTTP error: {e}")
    return None

data = fetch_data("https://api.agify.io?name=emma")
if data:
    print(data)
```

### Popular Libraries You Should Know

| Library | What it does | Install |
|---------|-------------|---------|
| `requests` | HTTP requests, fetch web data | `pip install requests` |
| `pandas` | Data analysis, spreadsheets | `pip install pandas` |
| `numpy` | Fast maths, arrays | `pip install numpy` |
| `pillow` | Image processing | `pip install pillow` |
| `pygame` | 2D game development | `pip install pygame` |
| `flask` | Web server (back end) | `pip install flask` |
| `rich` | Beautiful terminal output | `pip install rich` |
| `pytest` | Testing | `pip install pytest` |

### A Taste of pandas

```python
import pandas as pd   # pip install pandas

data = {
    "Name": ["Alice", "Bob", "Carol", "Dave"],
    "Score": [88, 75, 92, 61],
    "Grade": ["A", "B", "A", "D"]
}

df = pd.DataFrame(data)
print(df)
print(f"\nAverage score: {df[''Score''].mean():.1f}")
print(f"Top scorer: {df.loc[df[''Score''].idxmax(), ''Name'']}")
```

### The `requirements.txt` File

When sharing a project, list your dependencies in `requirements.txt`:

```
requests==2.31.0
pandas==2.1.0
pillow==10.1.0
```

Others can install everything at once:

```bash
pip install -r requirements.txt
```

### Virtual Environments (Brief Intro)

Use a virtual environment to keep project dependencies separate:

```bash
python -m venv myenv          # create
source myenv/bin/activate     # activate (Mac/Linux)
myenv\Scripts\activate        # activate (Windows)
pip install requests          # install inside venv
deactivate                    # exit
```

### Key Takeaways

- `pip install package_name` installs from PyPI
- `requests` is the go-to library for fetching web data and APIs
- Check `response.status_code` and handle errors with `try/except`
- Save dependencies in `requirements.txt`; install them with `pip install -r requirements.txt`
- Use virtual environments to keep projects isolated'),

('dev-l57', 'Python Turtle Graphics', 'developers', 'Python', 'en', 'intermediate', 45, 150, 57,
'## Python Turtle Graphics

The `turtle` module lets you draw shapes and patterns by controlling a virtual "turtle" that moves around the screen, leaving a trail. It is built into Python — no installation needed.

### Getting Started

```python
import turtle

# Set up the screen
screen = turtle.Screen()
screen.title("My Turtle Drawing")
screen.bgcolor("black")

# Create a turtle
t = turtle.Turtle()
t.color("white")
t.speed(5)    # 1 = slow, 10 = fast, 0 = instant

# Move the turtle
t.forward(100)   # move forward 100 pixels
t.left(90)       # turn left 90 degrees
t.forward(100)
t.left(90)
t.forward(100)
t.left(90)
t.forward(100)

turtle.done()    # keep window open
```

### Basic Commands

```python
t.forward(distance)    # or t.fd(distance)
t.backward(distance)   # or t.bk(distance)
t.left(angle)          # or t.lt(angle)
t.right(angle)         # or t.rt(angle)
t.goto(x, y)           # jump to coordinates
t.home()               # return to (0, 0)
t.penup()              # lift pen (no drawing)
t.pendown()            # put pen down (draw again)
t.pensize(width)       # set line thickness
t.speed(0)             # 0 = fastest
```

### Drawing a Star

```python
import turtle

t = turtle.Turtle()
t.color("gold")
t.bgcolor = "navy"
t.speed(0)

for _ in range(5):
    t.forward(150)
    t.right(144)   # 144 degrees makes a 5-pointed star

turtle.done()
```

### Drawing a House

```python
import turtle

t = turtle.Turtle()
t.speed(3)

# Draw the body (square)
t.color("brown")
t.begin_fill()
for _ in range(4):
    t.forward(150)
    t.left(90)
t.end_fill()

# Draw the roof (triangle)
t.color("red")
t.begin_fill()
t.goto(0, 150)     # bottom-left of roof
t.goto(75, 220)    # apex
t.goto(150, 150)   # bottom-right of roof
t.goto(0, 150)     # back to start
t.end_fill()

# Door
t.penup()
t.goto(55, 0)
t.pendown()
t.color("blue")
t.begin_fill()
for _ in range(2):
    t.forward(40)
    t.left(90)
    t.forward(60)
    t.left(90)
t.end_fill()

turtle.done()
```

### Drawing a Spiral

```python
import turtle

t = turtle.Turtle()
t.speed(0)
screen = turtle.Screen()
screen.bgcolor("black")

colours = ["red", "orange", "yellow", "green", "cyan", "blue", "purple"]

for i in range(200):
    t.color(colours[i % len(colours)])
    t.forward(i * 1.5)
    t.left(59)

turtle.done()
```

### Drawing with Functions

```python
import turtle

t = turtle.Turtle()
t.speed(0)

def draw_square(size, colour):
    t.color(colour)
    t.begin_fill()
    for _ in range(4):
        t.forward(size)
        t.left(90)
    t.end_fill()

def draw_triangle(size, colour):
    t.color(colour)
    t.begin_fill()
    for _ in range(3):
        t.forward(size)
        t.left(120)
    t.end_fill()

# Draw a pattern
colours = ["red", "blue", "green", "yellow", "purple"]
for i, colour in enumerate(colours):
    t.penup()
    t.goto(i * 80 - 160, 0)
    t.pendown()
    draw_square(60, colour)

turtle.done()
```

### Rainbow Polygon Spiral

```python
import turtle

t = turtle.Turtle()
t.speed(0)
screen = turtle.Screen()
screen.bgcolor("white")

colours = ["red", "orange", "yellow", "lime", "cyan", "blue", "violet", "pink"]
sides = 6

for i in range(80):
    t.color(colours[i % len(colours)])
    t.forward(i * 2)
    t.left(360 / sides + 5)

turtle.done()
```

### Key Takeaways

- `turtle` is built-in — `import turtle` is all you need
- Core commands: `forward()`, `left()`, `right()`, `goto()`, `penup()`, `pendown()`
- Use `begin_fill()` / `end_fill()` around a shape to fill it with colour
- Set colours with `t.color("red")` or `t.color("#FF0000")`
- `t.speed(0)` draws instantly — useful for complex patterns
- Loops make it easy to draw repeated shapes and spirals'),

('dev-l58', 'Python Random Module', 'developers', 'Python', 'en', 'intermediate', 35, 150, 58,
'## Python Random Module

The `random` module generates pseudo-random numbers and makes random choices. It is perfect for games, simulations, shuffling data, and any situation where you need unpredictable behaviour.

### Importing Random

```python
import random
```

That is all — `random` is part of Python''s standard library.

### `random.random()` — Float Between 0 and 1

```python
print(random.random())   # e.g. 0.7234561298
print(random.random())   # e.g. 0.1856743201

# Useful for probability checks
if random.random() < 0.3:
    print("30% chance event occurred!")
```

### `random.randint(a, b)` — Integer Between a and b (Inclusive)

```python
die = random.randint(1, 6)
print(f"You rolled: {die}")

# Simulate 10 dice rolls
rolls = [random.randint(1, 6) for _ in range(10)]
print(rolls)
```

### `random.choice()` — Pick One Item from a Sequence

```python
colours = ["red", "green", "blue", "yellow"]
print(random.choice(colours))    # one random colour

coin = random.choice(["heads", "tails"])
print(f"Coin flip: {coin}")

# Random letter
import string
letter = random.choice(string.ascii_lowercase)
print(f"Random letter: {letter}")
```

### `random.choices()` — Pick Multiple with Replacement

```python
# Pick 5 with possible repeats
sample = random.choices(["rock", "paper", "scissors"], k=5)
print(sample)

# Weighted choices (paper twice as likely)
moves = random.choices(
    ["rock", "paper", "scissors"],
    weights=[1, 2, 1],
    k=10
)
print(moves)
```

### `random.shuffle()` — Shuffle a List In Place

```python
deck = list(range(1, 14))   # [1, 2, 3, ..., 13]
print("Before:", deck)

random.shuffle(deck)
print("After: ", deck)

# Deal 5 cards
hand = deck[:5]
print("Hand:  ", hand)
```

### `random.sample()` — Pick Without Replacement

```python
names = ["Alice", "Bob", "Carol", "Dave", "Eve", "Frank"]

# Pick 3 unique names
winners = random.sample(names, 3)
print(f"Winners: {winners}")

# Lottery: pick 6 unique numbers from 1-49
lottery = random.sample(range(1, 50), 6)
lottery.sort()
print(f"Lottery numbers: {lottery}")
```

### Activity: Dice Roller

```python
import random

def roll_dice(sides=6):
    """Roll a single die with the given number of sides."""
    return random.randint(1, sides)

def roll_multiple(count, sides=6):
    """Roll multiple dice and return results."""
    return [roll_dice(sides) for _ in range(count)]

print("=== DICE ROLLER ===")
print(f"d6:  {roll_dice(6)}")
print(f"d20: {roll_dice(20)}")
print(f"d100: {roll_dice(100)}")

print("\nRolling 5d6:", roll_multiple(5, 6))
total = sum(roll_multiple(4, 6))
print(f"4d6 total: {total}")
```

### Activity: Card Picker

```python
import random

def create_deck():
    """Create a standard 52-card deck."""
    suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
    values = ["2", "3", "4", "5", "6", "7", "8", "9", "10",
              "Jack", "Queen", "King", "Ace"]
    deck = [f"{v} of {s}" for s in suits for v in values]
    return deck

deck = create_deck()
random.shuffle(deck)

print(f"Deck has {len(deck)} cards")
print(f"Top card: {deck[0]}")

# Deal a 5-card hand
hand = random.sample(deck, 5)
print("\nYour hand:")
for card in hand:
    print(f"  {card}")
```

### Setting a Seed for Reproducibility

```python
random.seed(42)   # same seed always gives same results
print(random.randint(1, 100))   # always 52
print(random.randint(1, 100))   # always 81

# Useful for testing and debugging
```

### Key Takeaways

- `random.random()` → float 0.0 to 1.0
- `random.randint(a, b)` → integer a to b (both inclusive)
- `random.choice(seq)` → one random item
- `random.shuffle(list)` → shuffle in place (modifies original)
- `random.sample(seq, k)` → k unique items without replacement
- `random.seed(n)` makes results reproducible (useful for testing)'),

('dev-l59', 'Python List Comprehensions', 'developers', 'Python', 'en', 'intermediate', 40, 150, 59,
'## Python List Comprehensions

List comprehensions are a concise, Pythonic way to create lists. Instead of writing a loop with `append()`, you write everything on one line. Once you get used to them, you will use them constantly.

### Basic Syntax

```python
# Long way:
squares = []
for n in range(10):
    squares.append(n ** 2)

# List comprehension (same result, one line!):
squares = [n ** 2 for n in range(10)]
print(squares)   # [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
```

The pattern is: `[expression for item in iterable]`

### Filtering with `if`

Add a condition to filter which items are included:

```python
# Only even numbers
evens = [n for n in range(20) if n % 2 == 0]
print(evens)   # [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]

# Squares of odd numbers only
odd_squares = [n**2 for n in range(1, 11) if n % 2 != 0]
print(odd_squares)   # [1, 9, 25, 49, 81]

# Words longer than 4 characters
words = ["cat", "python", "dog", "elephant", "bee", "coding"]
long_words = [w for w in words if len(w) > 4]
print(long_words)   # [''python'', ''elephant'', ''coding'']
```

### Transforming Data

```python
# Convert Celsius to Fahrenheit
celsius = [0, 10, 20, 30, 37, 100]
fahrenheit = [(c * 9/5) + 32 for c in celsius]
print(fahrenheit)   # [32.0, 50.0, 68.0, 86.0, 98.6, 212.0]

# Uppercase all strings
names = ["alice", "bob", "carol"]
upper_names = [name.upper() for name in names]
print(upper_names)   # [''ALICE'', ''BOB'', ''CAROL'']

# Extract first characters
initials = [name[0].upper() for name in names]
print(initials)   # [''A'', ''B'', ''C'']

# String lengths
lengths = [len(word) for word in words]
print(lengths)   # [3, 6, 3, 8, 3, 6]
```

### Practical Example 1: Passing Students

```python
scores = [72, 88, 45, 93, 61, 55, 80, 30, 95, 67]

passing = [s for s in scores if s >= 60]
failing = [s for s in scores if s < 60]
grades = ["Pass" if s >= 60 else "Fail" for s in scores]

print(f"Passing: {passing}")
print(f"Failing: {failing}")
print(f"Grades: {grades}")
```

### Practical Example 2: Flattening a List

```python
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

flat = [num for row in matrix for num in row]
print(flat)   # [1, 2, 3, 4, 5, 6, 7, 8, 9]
```

### Practical Example 3: Remove Duplicates While Preserving Order

```python
items = ["apple", "banana", "apple", "cherry", "banana", "date"]
seen = set()
unique = [x for x in items if not (x in seen or seen.add(x))]
print(unique)   # [''apple'', ''banana'', ''cherry'', ''date'']
```

### Dict Comprehensions

The same idea works for dictionaries:

```python
# {key: value for item in iterable}
names = ["Alice", "Bob", "Carol"]
scores = [88, 75, 92]

grade_book = {name: score for name, score in zip(names, scores)}
print(grade_book)   # {''Alice'': 88, ''Bob'': 75, ''Carol'': 92}

# Squares dict
squares = {n: n**2 for n in range(1, 6)}
print(squares)   # {1: 1, 2: 4, 3: 9, 4: 16, 5: 25}

# Filter a dict
high_scores = {name: score for name, score in grade_book.items() if score >= 85}
print(high_scores)   # {''Alice'': 88, ''Carol'': 92}
```

### Set Comprehensions

```python
words = ["hello", "world", "hello", "python", "world"]
unique_lengths = {len(w) for w in words}
print(unique_lengths)   # {5, 6} (set — no duplicates)
```

### When NOT to Use Comprehensions

Comprehensions are great for simple transformations, but if the logic is complex, a regular loop is clearer:

```python
# Too complex — use a regular loop instead
# result = [complex_function(x) if condition1(x) else other(x) for x in data if condition2(x)]

# Clear loop version:
result = []
for x in data:
    if condition2(x):
        if condition1(x):
            result.append(complex_function(x))
        else:
            result.append(other(x))
```

### Key Takeaways

- Syntax: `[expression for item in iterable]`
- Filter: `[expression for item in iterable if condition]`
- Dict comprehension: `{key: value for item in iterable}`
- Comprehensions are faster and more Pythonic than equivalent loops with `append()`
- Keep them readable — if a comprehension is hard to understand, use a regular loop')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;
