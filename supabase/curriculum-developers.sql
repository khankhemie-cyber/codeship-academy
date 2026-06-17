-- =============================================================================
-- CODEship Academy — Developers Level Lessons (dev-l01 to dev-l100)
-- =============================================================================

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l01', 'Welcome to JavaScript: The Language of the Web', 'developers', 'JavaScript', 'en', 'beginner', 30, 100, 1,
'## Welcome to JavaScript! 🚀

JavaScript is the programming language that makes websites interactive. Every website you love — from games to social media — uses JavaScript!

### What is JavaScript?

JavaScript is a **programming language** that runs in your browser. While HTML creates the structure and CSS makes it look good, JavaScript makes things **happen**.

```javascript
// Your first JavaScript!
console.log("Hello, World!");
alert("I am a developer!");
```

### What can JavaScript do?

- 🎮 Create games in the browser
- 📊 Build interactive charts and dashboards
- 💬 Create chat applications
- 🛒 Power shopping carts and forms
- 🤖 Control robots and IoT devices

### How to write JavaScript

JavaScript goes inside `<script>` tags in your HTML:

```html
<!DOCTYPE html>
<html>
<body>
  <h1>My Page</h1>

  <script>
    // This is a comment — the browser ignores it
    console.log("JavaScript is running!");

    // Showing a message
    document.querySelector("h1").textContent = "JavaScript changed me!";
  </script>
</body>
</html>
```

### The console

The browser console is where JavaScript talks to developers. Open it with F12 → Console tab.

```javascript
console.log("This appears in the console");
console.log("You can print numbers:", 42);
console.log("And even calculations:", 10 + 5);
```

### Activity: Write your first JS!

1. Open your Code Lab
2. Write `console.log("Hello! I am learning JavaScript!");`
3. Open the console (F12) and see your message
4. Try: `console.log(2 + 2)` — what do you see?

### Key Terms

| Term | Meaning |
|------|---------|
| **JavaScript** | Programming language for the web |
| **console.log()** | Displays text in the developer console |
| **Comment** | Text the browser ignores (starts with `//`) |
| **Script tag** | Where JavaScript lives in HTML |

### What''s Next?

Next, you''ll learn about **variables** — containers that store information in JavaScript!'),

('dev-l02', 'Variables and Data Types', 'developers', 'JavaScript', 'en', 'beginner', 35, 100, 2,
'## Variables and Data Types 📦

Variables are like labelled boxes that store information. Every program you write will use variables!

### Declaring Variables

In modern JavaScript, we use `const` and `let`:

```javascript
// const — for values that don''t change
const myName = "Alex";
const age = 11;
const pi = 3.14;

// let — for values that will change
let score = 0;
let lives = 3;
let currentLevel = "beginners";
```

### Data Types

JavaScript has several types of data:

#### 1. Strings (text)
```javascript
const name = "Jordan";
const greeting = ''Hello, world!'';
const multiLine = `My name is ${name} and I am ${age} years old.`;

console.log(greeting);      // Hello, world!
console.log(multiLine);     // My name is Jordan and I am 11 years old.
```

#### 2. Numbers
```javascript
const score = 100;
const price = 9.99;
const negative = -5;

console.log(score + 50);  // 150
console.log(price * 2);   // 19.98
```

#### 3. Booleans (true/false)
```javascript
const isLoggedIn = true;
const gameOver = false;
const isStudent = true;

console.log(isLoggedIn);  // true
console.log(!isLoggedIn); // false (! means NOT)
```

#### 4. Arrays (lists)
```javascript
const colours = ["red", "blue", "green"];
const scores = [95, 87, 72, 100];

console.log(colours[0]);   // red (first item, index 0!)
console.log(colours[2]);   // green (third item)
console.log(scores.length); // 4 (how many items)
```

#### 5. null and undefined
```javascript
let nothing = null;        // intentionally empty
let notDeclared;          // undefined — no value yet
```

### Template Literals (the backtick trick!)

```javascript
const name = "Sam";
const score = 95;

// Old way (messy):
console.log("Player " + name + " scored " + score + " points!");

// New way with template literals (backticks):
console.log(`Player ${name} scored ${score} points!`);
```

### Activity: Variable Practice

```javascript
// Create variables about yourself:
const myName = "Your Name Here";
const myAge = 11;
const myFavColour = "blue";
const iLoveCoding = true;

// Print them all with template literals:
console.log(`My name is ${myName}`);
console.log(`I am ${myAge} years old`);
console.log(`My favourite colour is ${myFavColour}`);
console.log(`Do I love coding? ${iLoveCoding}`);
```

### Important Rules
- Variable names cannot start with a number
- Use camelCase: `myVariable`, `firstName`, `isLoggedIn`
- `const` cannot be reassigned; `let` can
- Never use `var` in modern JavaScript'),

('dev-l03', 'Operators and Expressions', 'developers', 'JavaScript', 'en', 'beginner', 30, 100, 3,
'## Operators and Expressions ➕➖✖️➗

Operators let you perform calculations and comparisons in JavaScript.

### Arithmetic Operators

```javascript
const a = 10;
const b = 3;

console.log(a + b);   // 13 (addition)
console.log(a - b);   // 7 (subtraction)
console.log(a * b);   // 30 (multiplication)
console.log(a / b);   // 3.333... (division)
console.log(a % b);   // 1 (remainder/modulo)
console.log(a ** b);  // 1000 (exponentiation: 10³)
```

### Assignment Operators

```javascript
let score = 0;

score = score + 10;   // score is now 10
score += 5;           // shorthand! score is now 15
score -= 3;           // score is now 12
score *= 2;           // score is now 24
score++;              // score is now 25 (add 1)
score--;              // score is now 24 (subtract 1)
```

### Comparison Operators (return true or false)

```javascript
const x = 5;

console.log(x === 5);   // true (strictly equal)
console.log(x !== 3);   // true (not equal)
console.log(x > 3);     // true (greater than)
console.log(x < 10);    // true (less than)
console.log(x >= 5);    // true (greater than or equal)
console.log(x <= 5);    // true (less than or equal)

// Never use == (use ===)
console.log(5 == "5");  // true (dangerous! compares loosely)
console.log(5 === "5"); // false (safe! checks type too)
```

### Logical Operators

```javascript
const isRaining = true;
const hasUmbrella = false;

// AND (&&) — both must be true
console.log(isRaining && hasUmbrella); // false

// OR (||) — at least one must be true
console.log(isRaining || hasUmbrella); // true

// NOT (!) — reverses true/false
console.log(!isRaining); // false
console.log(!hasUmbrella); // true
```

### String Operators

```javascript
const first = "Hello";
const last = "World";

// Concatenation (joining strings)
console.log(first + " " + last); // "Hello World"

// Template literals (better!)
console.log(`${first} ${last}`); // "Hello World"
```

### Math Object

```javascript
console.log(Math.round(3.7));    // 4
console.log(Math.floor(3.9));    // 3 (round down)
console.log(Math.ceil(3.1));     // 4 (round up)
console.log(Math.abs(-5));       // 5 (absolute value)
console.log(Math.max(1,5,3));    // 5
console.log(Math.min(1,5,3));    // 1
console.log(Math.random());      // random 0 to 1
console.log(Math.pow(2, 10));    // 1024
```

### Activity: Calculator

Build a simple calculator:

```javascript
const num1 = 25;
const num2 = 7;

console.log(`${num1} + ${num2} = ${num1 + num2}`);
console.log(`${num1} - ${num2} = ${num1 - num2}`);
console.log(`${num1} × ${num2} = ${num1 * num2}`);
console.log(`${num1} ÷ ${num2} = ${(num1 / num2).toFixed(2)}`);
```'),

('dev-l04', 'Control Flow: If, Else, Switch', 'developers', 'JavaScript', 'en', 'beginner', 35, 100, 4,
'## Control Flow: Making Decisions 🔀

Programs need to make decisions! Control flow lets your code choose different paths.

### If Statement

```javascript
const score = 85;

if (score >= 90) {
  console.log("A - Excellent!");
}
```

### If...Else

```javascript
const age = 12;

if (age >= 18) {
  console.log("You can vote!");
} else {
  console.log("You''re too young to vote.");
}
```

### If...Else If...Else

```javascript
const grade = 75;

if (grade >= 90) {
  console.log("Grade: A");
} else if (grade >= 80) {
  console.log("Grade: B");
} else if (grade >= 70) {
  console.log("Grade: C");
} else if (grade >= 60) {
  console.log("Grade: D");
} else {
  console.log("Grade: F");
}
```

### Switch Statement

Use switch when comparing one value to many options:

```javascript
const day = "Monday";

switch (day) {
  case "Monday":
    console.log("Start of the week!");
    break;
  case "Friday":
    console.log("Almost weekend!");
    break;
  case "Saturday":
  case "Sunday":
    console.log("Weekend! 🎉");
    break;
  default:
    console.log("A regular day.");
}
```

### Ternary Operator (shorthand if/else)

```javascript
const isRaining = true;
const weather = isRaining ? "Bring an umbrella!" : "Enjoy the sunshine!";
console.log(weather); // "Bring an umbrella!"
```

### Activity: Grade Calculator

```javascript
function getGrade(score) {
  if (score >= 90) return "A";
  else if (score >= 80) return "B";
  else if (score >= 70) return "C";
  else if (score >= 60) return "D";
  else return "F";
}

console.log(getGrade(95));  // A
console.log(getGrade(72));  // C
console.log(getGrade(55));  // F
```'),

('dev-l05', 'Functions: Building Reusable Code', 'developers', 'JavaScript', 'en', 'beginner', 40, 100, 5,
'## Functions: The Building Blocks of Code 🔧

Functions are reusable blocks of code that perform a specific task. They make your code organised and DRY (Don''t Repeat Yourself)!

### Declaring Functions

```javascript
// Function declaration
function greet(name) {
  console.log(`Hello, ${name}!`);
}

greet("Alex");  // Hello, Alex!
greet("Sam");   // Hello, Sam!
```

### Functions with Return Values

```javascript
function add(a, b) {
  return a + b;
}

const result = add(5, 3);
console.log(result); // 8
console.log(add(10, 20)); // 30
```

### Arrow Functions (modern syntax)

```javascript
// Regular function
function double(n) {
  return n * 2;
}

// Arrow function — same thing!
const double = (n) => n * 2;
const double = n => n * 2;  // parentheses optional with 1 param

console.log(double(5));  // 10
```

### Default Parameters

```javascript
function greet(name = "friend", emoji = "👋") {
  return `Hello, ${name}! ${emoji}`;
}

console.log(greet("Alex"));        // Hello, Alex! 👋
console.log(greet("Sam", "🎉")); // Hello, Sam! 🎉
console.log(greet());             // Hello, friend! 👋
```

### Functions Calling Functions

```javascript
function celsiusToFahrenheit(celsius) {
  return (celsius * 9/5) + 32;
}

function describeWeather(celsius) {
  const fahrenheit = celsiusToFahrenheit(celsius);
  if (celsius > 25) {
    return `Hot! ${celsius}°C (${fahrenheit}°F)`;
  } else if (celsius > 10) {
    return `Nice! ${celsius}°C (${fahrenheit}°F)`;
  } else {
    return `Cold! ${celsius}°C (${fahrenheit}°F)`;
  }
}

console.log(describeWeather(30));  // Hot! 30°C (86°F)
console.log(describeWeather(15));  // Nice! 15°C (59°F)
```

### Activity: Build a Calculator Function

```javascript
function calculate(a, operation, b) {
  switch(operation) {
    case "+": return a + b;
    case "-": return a - b;
    case "*": return a * b;
    case "/": return b !== 0 ? a / b : "Cannot divide by zero!";
    default: return "Unknown operation";
  }
}

console.log(calculate(10, "+", 5));  // 15
console.log(calculate(20, "*", 3));  // 60
console.log(calculate(10, "/", 0));  // Cannot divide by zero!
```'),

('dev-l06', 'Arrays: Working with Lists of Data', 'developers', 'JavaScript', 'en', 'beginner', 40, 100, 6,
'## Arrays: Lists of Data 📋

Arrays store multiple values in a single variable — like a list!

### Creating Arrays

```javascript
const fruits = ["apple", "banana", "cherry"];
const numbers = [1, 2, 3, 4, 5];
const mixed = ["hello", 42, true, null];
const empty = [];
```

### Accessing Items

```javascript
const colours = ["red", "green", "blue"];

console.log(colours[0]);  // "red" (first item, index 0)
console.log(colours[1]);  // "green"
console.log(colours[2]);  // "blue" (last item)
console.log(colours.length); // 3
```

### Modifying Arrays

```javascript
const scores = [80, 75, 90];

scores.push(95);       // add to end: [80, 75, 90, 95]
scores.pop();          // remove from end: [80, 75, 90]
scores.unshift(70);    // add to start: [70, 80, 75, 90]
scores.shift();        // remove from start: [80, 75, 90]

scores[0] = 85;        // change first item: [85, 75, 90]
```

### Array Methods

```javascript
const nums = [5, 2, 8, 1, 9, 3];

// Sort
console.log([...nums].sort((a,b) => a - b)); // [1, 2, 3, 5, 8, 9]

// Reverse
console.log([...nums].reverse()); // [3, 9, 1, 8, 2, 5]

// Find
console.log(nums.find(n => n > 7));     // 8
console.log(nums.findIndex(n => n > 7)); // 2

// Filter (keep items that match)
const big = nums.filter(n => n > 5);
console.log(big); // [8, 9]

// Map (transform each item)
const doubled = nums.map(n => n * 2);
console.log(doubled); // [10, 4, 16, 2, 18, 6]

// Reduce (combine to single value)
const sum = nums.reduce((total, n) => total + n, 0);
console.log(sum); // 28
```

### Iterating Arrays

```javascript
const animals = ["cat", "dog", "bird"];

// for...of (recommended)
for (const animal of animals) {
  console.log(animal);
}

// forEach
animals.forEach(animal => {
  console.log(`I love ${animal}s!`);
});
```

### Activity: Student Grade Tracker

```javascript
const grades = [78, 92, 85, 67, 95, 88, 73];

const average = grades.reduce((sum, g) => sum + g, 0) / grades.length;
const highest = Math.max(...grades);
const lowest = Math.min(...grades);
const passing = grades.filter(g => g >= 70).length;

console.log(`Average: ${average.toFixed(1)}`);
console.log(`Highest: ${highest}`);
console.log(`Lowest: ${lowest}`);
console.log(`Passing: ${passing}/${grades.length}`);
```')
ON CONFLICT (slug) DO NOTHING;

-- Insert remaining lessons 7-100 with structured content
INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions)
SELECT
  'dev-l' || LPAD(n::text, GREATEST(2, length(n::text)), '0'),
  title,
  'developers',
  category,
  'en',
  difficulty,
  35,
  100,
  n,
  '## ' || title || E'\n\nThis lesson covers ' || category || ' concepts for developers.\n\n### What you will learn:\n- Core concepts of ' || title || '\n- Practical coding examples\n- Real-world applications\n\n### Code Examples:\n\n```javascript\n// Example code for ' || title || '\nconsole.log("Learning ' || title || '!");\n```\n\n### Activity:\nPractise the concepts from this lesson in your Code Lab!\n\n### Key Takeaways:\n- Understanding ' || category || ' is essential for web development\n- Practice makes perfect\n- Build something with what you learned!'
FROM (VALUES
  (7, 'Objects: Structured Data and Methods', 'JavaScript', 'intermediate'),
  (8, 'The DOM: Connecting JavaScript to HTML', 'JavaScript', 'intermediate'),
  (9, 'Events: Making Pages Respond to Users', 'JavaScript', 'intermediate'),
  (10, 'Building Interactive UIs: Forms and Validation', 'JavaScript', 'intermediate'),
  (11, 'Loops: Repeating Actions Efficiently', 'JavaScript', 'beginner'),
  (12, 'String Methods: Manipulating Text', 'JavaScript', 'beginner'),
  (13, 'Numbers and Math: Calculations in JavaScript', 'JavaScript', 'beginner'),
  (14, 'Dates and Times', 'JavaScript', 'intermediate'),
  (15, 'Local Storage: Persisting Data', 'JavaScript', 'intermediate'),
  (16, 'Fetch API and Promises: Talking to Servers', 'JavaScript', 'intermediate'),
  (17, 'Working with APIs: Real-World Data', 'JavaScript', 'intermediate'),
  (18, 'JSON: The Data Format of the Web', 'JavaScript', 'beginner'),
  (19, 'Building a Complete JavaScript App', 'JavaScript', 'intermediate'),
  (20, 'Debugging JavaScript: Finding and Fixing Bugs', 'JavaScript', 'beginner'),
  (21, 'Classes and Object-Oriented Programming', 'JavaScript', 'intermediate'),
  (22, 'Modules: Organising Code into Files', 'JavaScript', 'intermediate'),
  (23, 'Error Handling: Writing Robust Code', 'JavaScript', 'intermediate'),
  (24, 'Higher-Order Functions and Functional Programming', 'JavaScript', 'advanced'),
  (25, 'The Event Loop: How JavaScript Really Works', 'JavaScript', 'advanced'),
  (26, 'DOM Traversal and Manipulation Deep Dive', 'JavaScript', 'intermediate'),
  (27, 'Creating Animations with JavaScript', 'JavaScript', 'intermediate'),
  (28, 'Intersection Observer: Scroll Animations', 'JavaScript', 'advanced'),
  (29, 'Drag and Drop API', 'JavaScript', 'advanced'),
  (30, 'Building a Dynamic Table with Sorting and Filtering', 'Projects', 'intermediate'),
  (31, 'Web Storage: Cookie, localStorage, sessionStorage Compared', 'JavaScript', 'intermediate'),
  (32, 'URL API and History API', 'JavaScript', 'advanced'),
  (33, 'Canvas API: Drawing and Animation', 'JavaScript', 'intermediate'),
  (34, 'SVG Manipulation with JavaScript', 'JavaScript', 'advanced'),
  (35, 'Building a Data Visualisation Dashboard', 'Projects', 'advanced'),
  (36, 'Introduction to Node.js: JavaScript on the Server', 'Node.js', 'intermediate'),
  (37, 'npm and Packages: Using Others'' Code', 'Node.js', 'beginner'),
  (38, 'Building a Command-Line Tool with Node.js', 'Node.js', 'intermediate'),
  (39, 'File System API in Node.js', 'Node.js', 'intermediate'),
  (40, 'Introduction to Express: Building a Web Server', 'Node.js', 'intermediate'),
  (41, 'REST API Design Principles', 'Node.js', 'intermediate'),
  (42, 'Building a REST API with Express', 'Node.js', 'intermediate'),
  (43, 'Middleware and Route Handling', 'Node.js', 'advanced'),
  (44, 'Introduction to Databases: SQL vs NoSQL', 'Node.js', 'beginner'),
  (45, 'Introduction to React: Component-Based UI', 'React', 'intermediate'),
  (46, 'React JSX and the Virtual DOM', 'React', 'intermediate'),
  (47, 'React Props: Passing Data to Components', 'React', 'intermediate'),
  (48, 'React State with useState Hook', 'React', 'intermediate'),
  (49, 'React Effects with useEffect Hook', 'React', 'intermediate'),
  (50, 'React: Building a Complete Component', 'React', 'intermediate'),
  (51, 'React: Lists and Keys', 'React', 'intermediate'),
  (52, 'React: Forms and Controlled Inputs', 'React', 'intermediate'),
  (53, 'React: Lifting State Up', 'React', 'advanced'),
  (54, 'React: Context for Global State', 'React', 'advanced'),
  (55, 'Introduction to Python: The Second Language', 'Python', 'beginner'),
  (56, 'Python Variables and Data Types', 'Python', 'beginner'),
  (57, 'Python Control Flow: If and Loops', 'Python', 'beginner'),
  (58, 'Python Functions', 'Python', 'beginner'),
  (59, 'Python Lists and Dictionaries', 'Python', 'intermediate'),
  (60, 'Python: Working with Files', 'Python', 'intermediate'),
  (61, 'Python: Reading APIs with requests Library', 'Python', 'intermediate'),
  (62, 'Python: Simple Data Analysis with Lists', 'Python', 'intermediate'),
  (63, 'Building a Python Quiz Game', 'Python', 'intermediate'),
  (64, 'Building a Python Web Scraper (Basics)', 'Python', 'advanced'),
  (65, 'Git and Version Control: Tracking Your Code', 'Fundamentals', 'intermediate'),
  (66, 'GitHub: Collaboration and Open Source', 'Fundamentals', 'intermediate'),
  (67, 'Command Line Interface Basics', 'Fundamentals', 'beginner'),
  (68, 'How the Internet Works: HTTP, DNS, Servers Deep Dive', 'Fundamentals', 'intermediate'),
  (69, 'Web Security Basics: XSS, CSRF, HTTPS', 'Fundamentals', 'advanced'),
  (70, 'Responsive Design with JavaScript: ResizeObserver', 'JavaScript', 'advanced'),
  (71, 'Performance Optimization: JavaScript Profiling', 'JavaScript', 'advanced'),
  (72, 'Web Workers: Background Processing', 'JavaScript', 'advanced'),
  (73, 'Progressive Web Apps: Making Sites Work Offline', 'JavaScript', 'advanced'),
  (74, 'WebSockets: Real-Time Communication', 'JavaScript', 'advanced'),
  (75, 'Building a Chat Application', 'Projects', 'advanced'),
  (76, 'Data Structures: Stacks and Queues in JS', 'Algorithms', 'intermediate'),
  (77, 'Data Structures: Linked Lists', 'Algorithms', 'advanced'),
  (78, 'Data Structures: Trees and Graphs', 'Algorithms', 'advanced'),
  (79, 'Algorithms: Sorting and Searching', 'Algorithms', 'intermediate'),
  (80, 'Algorithms: Big O Notation and Complexity', 'Algorithms', 'advanced'),
  (81, 'Testing JavaScript with Jest', 'Testing', 'intermediate'),
  (82, 'Unit Tests and Test-Driven Development', 'Testing', 'advanced'),
  (83, 'Building a Full-Stack App: Front End', 'Projects', 'advanced'),
  (84, 'Building a Full-Stack App: Back End', 'Projects', 'advanced'),
  (85, 'Deploying a Node.js App to the Web', 'Fundamentals', 'intermediate'),
  (86, 'Introduction to TypeScript', 'JavaScript', 'intermediate'),
  (87, 'TypeScript Types and Interfaces', 'JavaScript', 'intermediate'),
  (88, 'CSS-in-JS: Styled Components Intro', 'React', 'advanced'),
  (89, 'State Management with useReducer', 'React', 'advanced'),
  (90, 'Building a Portfolio with React', 'Projects', 'advanced'),
  (91, 'Accessibility in JavaScript Applications', 'Fundamentals', 'intermediate'),
  (92, 'Internationalisation (i18n) in JavaScript', 'JavaScript', 'advanced'),
  (93, 'Building a Real-Time Dashboard', 'Projects', 'advanced'),
  (94, 'Introduction to Machine Learning Concepts', 'Fundamentals', 'beginner'),
  (95, 'Using ML APIs in JavaScript (Teachable Machine)', 'JavaScript', 'advanced'),
  (96, 'Code Review and Professional Practices', 'Fundamentals', 'intermediate'),
  (97, 'Developers Capstone: Full-Stack Project Specification', 'Projects', 'advanced'),
  (98, 'Technical Interviews: Solving Coding Challenges', 'Fundamentals', 'advanced'),
  (99, 'Developers Showcase: Present Your Best Work', 'Projects', 'intermediate'),
  (100, 'Developers Graduation: Ready for Engineers Level', 'Fundamentals', 'intermediate')
) AS t(n, title, category, difficulty)
ON CONFLICT (slug) DO NOTHING;

-- Developers Projects (dev-p01 to dev-p100)
INSERT INTO projects (slug, title, level, category, starter_code, instructions, tags, xp_reward, sort_order)
SELECT
  'dev-p' || LPAD(n::text, GREATEST(2, length(n::text)), '0'),
  title,
  'developers',
  category,
  starter_code,
  '## ' || title || E'\n\nBuild this project using your JavaScript skills!\n\n### Steps:\n1. Set up your HTML structure\n2. Write the JavaScript logic\n3. Style with CSS\n4. Test all features\n5. Add any extra functionality\n\n### Remember:\n- Use `const` and `let` (never `var`)\n- Handle errors gracefully\n- Make it responsive',
  ARRAY['developers', 'javascript', 'project'],
  200,
  n
FROM (VALUES
  (1, 'Time-Aware Greeting App', 'JavaScript', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Greeting App</title></head><body><h1 id="greeting">Loading...</h1><script>const hour = new Date().getHours();const greet = hour < 12 ? "Good Morning" : hour < 17 ? "Good Afternoon" : "Good Evening";document.getElementById("greeting").textContent = greet + "! ☀️";</script></body></html>'),
  (2, 'DOM Calculator', 'JavaScript', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Calculator</title><style>body{font-family:Arial;display:flex;justify-content:center;padding:40px;}.calc{background:#1E2140;border-radius:16px;padding:20px;}.display{background:#0a0a1a;color:white;font-size:28px;padding:16px;border-radius:8px;text-align:right;margin-bottom:12px;min-height:60px;}.btn{background:#3A3D5C;color:white;border:none;padding:16px;margin:4px;border-radius:8px;font-size:18px;cursor:pointer;width:60px;}.btn:hover{background:#F5C518;color:#1E2140;}.btn-op{background:#F5C518;color:#1E2140;}.btn-eq{background:#F5C518;color:#1E2140;grid-column:span 2;width:128px;}</style></head><body><div class="calc"><div class="display" id="display">0</div><div><button class="btn" onclick="calc(7)">7</button><button class="btn" onclick="calc(8)">8</button><button class="btn" onclick="calc(9)">9</button><button class="btn btn-op" onclick="calc(''/'')">÷</button><button class="btn" onclick="calc(4)">4</button><button class="btn" onclick="calc(5)">5</button><button class="btn" onclick="calc(6)">6</button><button class="btn btn-op" onclick="calc(''*'')">×</button><button class="btn" onclick="calc(1)">1</button><button class="btn" onclick="calc(2)">2</button><button class="btn" onclick="calc(3)">3</button><button class="btn btn-op" onclick="calc(''-'')">−</button><button class="btn" onclick="calc(0)">0</button><button class="btn" onclick="calc(''.'')">.</button><button class="btn btn-op" onclick="calc(''+'')">+</button><button class="btn btn-eq" onclick="evaluate()">=</button><button class="btn" onclick="clear_()">C</button></div></div><script>let expr="";function calc(v){expr+=v;document.getElementById("display").textContent=expr;}function evaluate(){try{expr=eval(expr).toString();document.getElementById("display").textContent=expr;}catch{document.getElementById("display").textContent="Error";expr="";}}function clear_(){expr="";document.getElementById("display").textContent="0";}</script></body></html>'),
  (3, 'Live Character Counter', 'JavaScript', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Character Counter</title><style>body{font-family:Arial;padding:40px;max-width:500px;margin:0 auto;}textarea{width:100%;height:150px;padding:12px;font-size:16px;border:2px solid #ddd;border-radius:8px;resize:vertical;}.counter{text-align:right;font-size:14px;color:#666;margin-top:4px;}.limit{color:red;}</style></head><body><h1>✍️ Character Counter</h1><textarea id="text" maxlength="280" placeholder="Start typing..."></textarea><div class="counter"><span id="count">0</span>/280 characters</div><script>document.getElementById("text").addEventListener("input",function(){const count=this.value.length;document.getElementById("count").textContent=count;document.querySelector(".counter").className="counter"+(count>250?" limit":"");});</script></body></html>'),
  (4, 'Colour Palette Generator', 'JavaScript', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Palette Generator</title><style>body{font-family:Arial;padding:20px;}.palette{display:flex;gap:0;border-radius:12px;overflow:hidden;margin:20px 0;}.swatch{flex:1;height:120px;display:flex;align-items:flex-end;padding:8px;font-size:12px;font-weight:bold;cursor:pointer;transition:flex 0.3s;}.swatch:hover{flex:2;}</style></head><body><h1>🎨 Random Palette</h1><button onclick="generate()" style="padding:12px 24px;background:#1E2140;color:white;border:none;border-radius:8px;cursor:pointer;font-size:16px;">Generate New Palette</button><div class="palette" id="palette"></div><script>function randomHex(){return "#"+Math.floor(Math.random()*16777215).toString(16).padStart(6,"0");}function generate(){const palette=document.getElementById("palette");palette.innerHTML="";for(let i=0;i<5;i++){const color=randomHex();const div=document.createElement("div");div.className="swatch";div.style.backgroundColor=color;div.textContent=color;div.onclick=()=>navigator.clipboard.writeText(color);palette.appendChild(div);}}generate();</script></body></html>'),
  (5, 'Weather App with API', 'JavaScript', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Weather App</title><style>body{font-family:Arial;padding:40px;max-width:400px;margin:0 auto;background:#87CEEB;}.card{background:white;border-radius:20px;padding:30px;text-align:center;box-shadow:0 8px 32px rgba(0,0,0,0.2);}.temp{font-size:64px;font-weight:bold;}.city{font-size:24px;color:#666;}input{width:100%;padding:12px;border:2px solid #ddd;border-radius:8px;font-size:16px;margin-bottom:12px;}button{width:100%;padding:12px;background:#1E2140;color:white;border:none;border-radius:8px;font-size:16px;cursor:pointer;}</style></head><body><div class="card"><h1>🌤️ Weather App</h1><input id="city" placeholder="Enter city name..." value="Toronto"><button onclick="getWeather()">Get Weather</button><div id="result"></div></div><script>async function getWeather(){const city=document.getElementById("city").value;// Note: You need a free OpenWeatherMap API key
// Get one free at openweathermap.org
const API_KEY="YOUR_API_KEY_HERE";const url=`https://api.openweathermap.org/data/2.5/weather?q=${city}&units=metric&appid=${API_KEY}`;try{const r=await fetch(url);const d=await r.json();document.getElementById("result").innerHTML=`<div class="temp">${Math.round(d.main.temp)}°C</div><div class="city">${d.name}, ${d.sys.country}</div><p>${d.weather[0].description}</p>`;}catch(e){document.getElementById("result").innerHTML="<p>City not found!</p>";}}getWeather();</script></body></html>')
) AS t(n, title, category, starter_code)
ON CONFLICT (slug) DO NOTHING;

-- Insert remaining projects 6-100
INSERT INTO projects (slug, title, level, category, starter_code, instructions, tags, xp_reward, sort_order)
SELECT
  'dev-p' || LPAD(n::text, GREATEST(2, length(n::text)), '0'),
  title,
  'developers',
  category,
  '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>' || title || '</title><style>body{font-family:Arial,sans-serif;margin:0;padding:20px;}</style></head><body><h1>' || title || '</h1><!-- Start building here --><script>// Your JavaScript goes here</script></body></html>',
  '## ' || title || E'\n\nBuild this ' || category || ' project!\n\n### Steps:\n1. Plan your project structure\n2. Write the HTML and CSS\n3. Add JavaScript functionality\n4. Test everything\n5. Polish and submit',
  ARRAY['developers', lower(category), 'project'],
  200,
  n
FROM (VALUES
  (6, 'To-Do App with localStorage', 'JavaScript'),
  (7, 'Quiz App with Timer', 'JavaScript'),
  (8, 'GitHub Profile Viewer', 'JavaScript'),
  (9, 'Currency Converter', 'JavaScript'),
  (10, 'Infinite Scroll Image Gallery', 'JavaScript'),
  (11, 'Markdown Preview Editor', 'JavaScript'),
  (12, 'Pokémon Team Builder', 'JavaScript'),
  (13, 'JavaScript Typing Speed Test', 'JavaScript'),
  (14, 'Recipe Finder App', 'JavaScript'),
  (15, 'JavaScript Memory Card Game', 'JavaScript'),
  (16, 'Note-Taking App', 'JavaScript'),
  (17, 'Interactive Quiz Builder', 'JavaScript'),
  (18, 'Countdown Timer with Alerts', 'JavaScript'),
  (19, 'Expense Tracker', 'JavaScript'),
  (20, 'Music Player UI', 'JavaScript'),
  (21, 'Drag-and-Drop Kanban Board', 'JavaScript'),
  (22, 'JavaScript Slideshow/Carousel', 'JavaScript'),
  (23, 'Word Frequency Analyser', 'JavaScript'),
  (24, 'JavaScript Paint/Drawing App', 'JavaScript'),
  (25, 'Scrolling Parallax Page', 'JavaScript'),
  (26, 'Star Rating Component', 'JavaScript'),
  (27, 'Accordion FAQ Component', 'JavaScript'),
  (28, 'Modal Dialog System', 'JavaScript'),
  (29, 'Form Multi-Step Wizard', 'JavaScript'),
  (30, 'JavaScript Stopwatch', 'JavaScript'),
  (31, 'Country Capitals Quiz', 'JavaScript'),
  (32, 'Random Quote Generator with Favourites', 'JavaScript'),
  (33, 'Currency Watchlist', 'JavaScript'),
  (34, 'Live Score Ticker', 'JavaScript'),
  (35, 'Book Search with OpenLibrary API', 'JavaScript'),
  (36, 'Pomodoro Timer App', 'JavaScript'),
  (37, 'Dark/Light Mode Toggle with Persistence', 'JavaScript'),
  (38, 'JavaScript Sorting Visualiser', 'JavaScript'),
  (39, 'Emoji Picker Component', 'JavaScript'),
  (40, 'Image Colour Extractor', 'JavaScript'),
  (41, 'Autocomplete Search Component', 'JavaScript'),
  (42, 'JavaScript Battleship Game', 'JavaScript'),
  (43, 'Snake Game on Canvas', 'JavaScript'),
  (44, 'Tetris Clone (Simplified)', 'JavaScript'),
  (45, 'Flappy Bird Clone', 'JavaScript'),
  (46, 'Typing Effect Text Animation', 'JavaScript'),
  (47, 'JavaScript Password Generator', 'JavaScript'),
  (48, 'Colour Mixing Game', 'JavaScript'),
  (49, 'Meme Generator', 'JavaScript'),
  (50, 'Developers Portfolio Mid-Point Review', 'JavaScript'),
  (51, 'Node.js Hello World Server', 'Node.js'),
  (52, 'Express REST API — Users Resource', 'Node.js'),
  (53, 'File-Based Blog with Node.js', 'Node.js'),
  (54, 'Express + JSON File Database', 'Node.js'),
  (55, 'Command-Line Number Game with Node.js', 'Node.js'),
  (56, 'Python Calculator', 'Python'),
  (57, 'Python Number Guessing Game', 'Python'),
  (58, 'Python Word Counter', 'Python'),
  (59, 'Python Simple Quiz Game', 'Python'),
  (60, 'Python File Line Counter', 'Python'),
  (61, 'React Counter Component', 'React'),
  (62, 'React Todo List', 'React'),
  (63, 'React Weather Widget', 'React'),
  (64, 'React Quiz Component', 'React'),
  (65, 'React Shopping Cart', 'React'),
  (66, 'Git Commit History Viewer', 'JavaScript'),
  (67, 'JavaScript Code Formatter (Regex)', 'JavaScript'),
  (68, 'Browser Extension Starter', 'JavaScript'),
  (69, 'Web Speech API Voice Notes', 'JavaScript'),
  (70, 'Geolocation Map App', 'JavaScript'),
  (71, 'Live CSS Editor (CodePen Clone)', 'JavaScript'),
  (72, 'Notification Permission Demo', 'JavaScript'),
  (73, 'IndexedDB Todo App', 'JavaScript'),
  (74, 'Service Worker Cache Demo', 'JavaScript'),
  (75, 'Real-Time Chat with WebSockets', 'JavaScript'),
  (76, 'Data Table with Sort/Filter/Paginate', 'JavaScript'),
  (77, 'CSV Parser and Visualiser', 'JavaScript'),
  (78, 'JavaScript Regex Tester', 'JavaScript'),
  (79, 'Infinite Scroll News Feed', 'JavaScript'),
  (80, 'User Authentication UI Flow', 'JavaScript'),
  (81, 'Jest Unit Test Suite', 'Testing'),
  (82, 'Accessibility Audit Tool', 'JavaScript'),
  (83, 'Performance Monitor Widget', 'JavaScript'),
  (84, 'Internationalised (i18n) App', 'JavaScript'),
  (85, 'JavaScript Animation Library', 'JavaScript'),
  (86, 'TypeScript To-Do App', 'JavaScript'),
  (87, 'Graph Data Visualisation', 'JavaScript'),
  (88, 'WebGL Simple Demo', 'JavaScript'),
  (89, 'Progressive Web App (PWA)', 'JavaScript'),
  (90, 'Full-Stack: React Front End', 'React'),
  (91, 'Full-Stack: Express Back End', 'Node.js'),
  (92, 'Full-Stack: Connect Front and Back', 'JavaScript'),
  (93, 'Deploy a Full-Stack App', 'JavaScript'),
  (94, 'Technical Interview Practice Problems', 'JavaScript'),
  (95, 'Code Review: Review a Peer Project', 'JavaScript'),
  (96, 'Open Project: Build Your Own Tool', 'JavaScript'),
  (97, 'Developers Capstone: Full-Stack App', 'JavaScript'),
  (98, 'Video Demo of Your Best Project', 'JavaScript'),
  (99, 'Developers Showcase Presentation', 'JavaScript'),
  (100, 'Developers Graduation: Ready for Engineers', 'JavaScript')
) AS t(n, title, category)
ON CONFLICT (slug) DO NOTHING;
