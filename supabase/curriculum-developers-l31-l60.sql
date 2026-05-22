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
