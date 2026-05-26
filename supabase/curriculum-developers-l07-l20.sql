-- =============================================================================
-- CODEship Academy — Developers Level Lessons (dev-l07 to dev-l20)
-- 14 lessons: JavaScript-focused, Ages 11-14, Intermediate
-- Run after schema.sql and curriculum.sql
-- =============================================================================

INSERT INTO public.lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES

('dev-l07', 'The DOM: Connecting JS to HTML', 'developers', 'DOM', 'en', 'intermediate', 35, 150, 7,
'## The DOM: Connecting JS to HTML 🌐

Every website you see in a browser is built from HTML — but JavaScript is what makes it interactive. The secret bridge between JavaScript and HTML is called the **DOM**. Once you understand the DOM, you can make any webpage respond to your code!

### What Is the DOM?

DOM stands for **Document Object Model**. When your browser loads an HTML page, it reads all the HTML tags and builds a tree-like structure in memory — that is the DOM. JavaScript can then read and change this tree, which updates what you see on screen.

Think of it like this: HTML is a blueprint for a house, and the DOM is the actual house. JavaScript is the builder who can add rooms, paint walls, or knock things down — all while you are living in it!

```html
<!DOCTYPE html>
<html>
  <body>
    <h1 id="title">Hello World</h1>
    <p class="intro">Welcome to my page.</p>
    <button id="myBtn">Click me!</button>
  </body>
</html>
```

The DOM turns this HTML into a tree where every element is a **node** that JavaScript can access.

### Selecting Elements

To do anything useful, you first need to grab the element you want to work with. JavaScript gives you several ways to do this:

#### querySelector — the modern way
```javascript
// Select by ID
const title = document.querySelector("#title");

// Select by class
const intro = document.querySelector(".intro");

// Select by tag name
const button = document.querySelector("button");

// Select a nested element
const navLink = document.querySelector("nav a");
```

`querySelector` always returns the **first** matching element. If nothing is found, it returns `null`.

#### getElementById — the classic way
```javascript
const title = document.getElementById("title");
// Note: no # symbol here!
```

#### querySelectorAll — grab multiple elements
```javascript
const allParagraphs = document.querySelectorAll("p");
// Returns a NodeList — like an array of elements
```

### Reading and Changing Text

Once you have an element, you can read or change its content:

```javascript
const title = document.querySelector("#title");

// READ the current text
console.log(title.textContent); // "Hello World"

// CHANGE the text
title.textContent = "JavaScript changed me!";
```

#### textContent vs innerHTML

`textContent` is safe — it treats everything as plain text. `innerHTML` lets you insert HTML tags, but be careful!

```javascript
// Safe — displays as text
element.textContent = "<b>Bold?</b>"; // Shows literally: <b>Bold?</b>

// Powerful but risky — renders as HTML
element.innerHTML = "<b>Bold!</b>"; // Shows: Bold!

// NEVER do this with user input — it''s a security risk!
// element.innerHTML = userInput; // Danger! XSS attack possible
```

Use `textContent` for plain text. Only use `innerHTML` when you control the content.

### Working with classList

Every HTML element has a `classList` property that lets you add, remove, or toggle CSS classes:

```javascript
const box = document.querySelector(".box");

// Add a class
box.classList.add("highlighted");

// Remove a class
box.classList.remove("hidden");

// Toggle — adds if missing, removes if present
box.classList.toggle("active");

// Check if a class exists
if (box.classList.contains("active")) {
  console.log("The box is active!");
}
```

This is incredibly powerful — you can write CSS classes for different states (hidden, highlighted, error, success) and then switch between them with JavaScript!

### Activity: Build a Live Profile Card 👤

Create an HTML page with a profile card, then use JavaScript to update it:

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    .card { border: 2px solid #333; padding: 20px; width: 200px; }
    .highlight { background-color: yellow; }
  </style>
</head>
<body>
  <div class="card" id="profile">
    <h2 id="name">Your Name</h2>
    <p id="role">Your Role</p>
    <button onclick="updateCard()">Update Card</button>
  </div>

  <script>
    function updateCard() {
      document.querySelector("#name").textContent = "Alex Developer";
      document.querySelector("#role").textContent = "Junior JavaScript Engineer";
      document.querySelector("#profile").classList.add("highlight");
    }
  </script>
</body>
</html>
```

**Challenge:** Add more fields to the card (favourite language, years coding, etc.) and update them all with the button click.

### Key Terms

| Term | Meaning |
|------|---------|
| **DOM** | Document Object Model — the browser''s tree of your HTML |
| **querySelector** | Finds the first element matching a CSS selector |
| **textContent** | The plain text inside an element |
| **innerHTML** | The HTML content inside an element (use carefully!) |
| **classList** | The list of CSS classes on an element |

### What''s Next?
Now you can grab elements and change their content. Next lesson: making your page react to **user events** like clicks and typing!'),

('dev-l08', 'DOM Events: Click, Input, Keyboard', 'developers', 'DOM', 'en', 'intermediate', 35, 150, 8,
'## DOM Events: Click, Input, Keyboard ⚡

Websites come alive when they respond to what users do. Clicking a button, typing in a box, pressing a key — these are all **events**. In this lesson, you will learn how to listen for events and respond to them with JavaScript!

### What Is an Event?

An event is anything that happens in the browser — usually triggered by the user. Examples:
- 🖱️ Clicking a button
- ⌨️ Pressing a key
- 📝 Typing in an input field
- 🖱️ Moving the mouse
- 📜 Scrolling the page

JavaScript can **listen** for these events and run code when they happen. This is called an **event listener**.

### addEventListener: The Modern Way

The best way to handle events is with `addEventListener`:

```javascript
const button = document.querySelector("#myButton");

button.addEventListener("click", function() {
  console.log("Button was clicked!");
});
```

The pattern is: **element.addEventListener("event name", function to run)**

You can also use an arrow function (cleaner syntax):

```javascript
button.addEventListener("click", () => {
  console.log("Button clicked!");
});
```

### The Click Event

The most common event! Fires whenever the user clicks on an element.

```javascript
const btn = document.querySelector("#changeColour");

btn.addEventListener("click", () => {
  document.body.style.backgroundColor = "lightblue";
  btn.textContent = "Colour changed!";
});
```

You can add click listeners to almost any element — buttons, links, images, divs...

### The Input Event

The `input` event fires every time the user types a character in a text field. It''s perfect for live previews!

```javascript
const nameInput = document.querySelector("#nameInput");
const greeting = document.querySelector("#greeting");

nameInput.addEventListener("input", () => {
  const name = nameInput.value; // .value gets the current text
  greeting.textContent = "Hello, " + name + "!";
});
```

Every time the user types a letter, the greeting updates instantly. That''s reactive programming!

### The Keydown Event

The `keydown` event fires when the user presses any key. You can check **which** key was pressed using the event object:

```javascript
document.addEventListener("keydown", (event) => {
  console.log("Key pressed:", event.key);

  if (event.key === "ArrowRight") {
    console.log("Moving right!");
  }
  if (event.key === "Enter") {
    console.log("Enter was pressed!");
  }
  if (event.key === "Escape") {
    console.log("Escape!");
  }
});
```

The **event object** (called `event` here, but you can name it anything) is automatically passed to your function. It contains loads of useful information about what happened.

### The Event Object

Every event listener receives an event object with details about the event:

```javascript
button.addEventListener("click", (event) => {
  console.log(event.type);        // "click"
  console.log(event.target);      // the element that was clicked
  console.log(event.target.id);   // the id of the clicked element
  console.log(event.timeStamp);   // when it happened
});
```

This is especially useful when you have many buttons and want to know which one was clicked!

### Preventing Default Behaviour

Some elements have built-in behaviour — links navigate to a URL, forms submit and reload the page. You can stop this with `event.preventDefault()`:

```javascript
const link = document.querySelector("a");

link.addEventListener("click", (event) => {
  event.preventDefault(); // Stop the browser from navigating
  console.log("Link clicked, but we stayed on the page!");
});
```

### Activity: Build a Live Chat Simulator 💬

Create a simple chat simulator that responds to your messages:

```html
<!DOCTYPE html>
<html>
<body>
  <div id="chat" style="border:1px solid #ccc; height:200px; overflow-y:auto; padding:10px;"></div>
  <input type="text" id="messageInput" placeholder="Type a message...">
  <button id="sendBtn">Send</button>

  <script>
    const chat = document.querySelector("#chat");
    const input = document.querySelector("#messageInput");
    const sendBtn = document.querySelector("#sendBtn");

    const responses = ["Cool!", "Tell me more!", "Interesting!", "I agree!", "Really?"];

    function sendMessage() {
      const message = input.value.trim();
      if (!message) return;

      chat.innerHTML += "<p><strong>You:</strong> " + message + "</p>";

      const reply = responses[Math.floor(Math.random() * responses.length)];
      chat.innerHTML += "<p><em>Bot:</em> " + reply + "</p>";

      input.value = "";
      chat.scrollTop = chat.scrollHeight;
    }

    sendBtn.addEventListener("click", sendMessage);

    input.addEventListener("keydown", (event) => {
      if (event.key === "Enter") sendMessage();
    });
  </script>
</body>
</html>
```

**Challenge:** Add a "Clear Chat" button and a counter showing how many messages you have sent.

### Common Event Names

| Event | When it fires |
|-------|--------------|
| `click` | Mouse button clicked |
| `input` | User types in a field |
| `keydown` | Key is pressed |
| `keyup` | Key is released |
| `mouseover` | Mouse enters an element |
| `submit` | A form is submitted |
| `load` | Page finishes loading |

### What''s Next?
You can now listen to what users do. Next: **creating and removing elements** — adding new content to the page dynamically!'),

('dev-l09', 'Creating and Removing Elements', 'developers', 'DOM', 'en', 'intermediate', 35, 150, 9,
'## Creating and Removing Elements 🏗️

Static HTML is just the beginning. With JavaScript, you can build new HTML elements on the fly and add them to your page — or remove ones that are no longer needed. This is how dynamic apps like social media feeds and to-do lists work!

### createElement: Building New Elements

Use `document.createElement()` to create a new HTML element. It starts empty and lives in memory — not on the page yet.

```javascript
// Create a new paragraph element
const newParagraph = document.createElement("p");

// Give it some text
newParagraph.textContent = "I was created by JavaScript!";

// Give it a class
newParagraph.classList.add("dynamic-text");
```

### appendChild: Adding to the Page

Once your element is ready, use `appendChild()` to add it inside another element:

```javascript
const container = document.querySelector("#container");

const newItem = document.createElement("li");
newItem.textContent = "New list item!";

container.appendChild(newItem); // Adds at the END of container
```

`appendChild` always adds the new element as the **last child** of the parent.

### insertBefore: Precise Placement

If you want to insert before a specific element, use `insertBefore`:

```javascript
const list = document.querySelector("ul");
const firstItem = list.querySelector("li"); // The first li

const newItem = document.createElement("li");
newItem.textContent = "I am first now!";

list.insertBefore(newItem, firstItem); // Insert before the first item
```

### removeChild: Deleting Elements

To remove an element, you call `removeChild` on its parent:

```javascript
const list = document.querySelector("ul");
const itemToRemove = document.querySelector("#removeMe");

list.removeChild(itemToRemove);
```

Or you can use the modern shortcut — `element.remove()`:

```javascript
const item = document.querySelector("#removeMe");
item.remove(); // Removes itself — no parent needed!
```

### Setting Attributes

You can set any HTML attribute on your new elements:

```javascript
const link = document.createElement("a");
link.textContent = "Visit CODEship";
link.setAttribute("href", "https://codeship.academy");
link.setAttribute("target", "_blank"); // Open in new tab

const image = document.createElement("img");
image.setAttribute("src", "cat.png");
image.setAttribute("alt", "A cute cat");
```

### Building a Full Element Tree

You can create complex nested structures:

```javascript
// Create a card component
const card = document.createElement("div");
card.classList.add("card");

const heading = document.createElement("h3");
heading.textContent = "New Card";

const description = document.createElement("p");
description.textContent = "This card was built entirely with JavaScript!";

const deleteBtn = document.createElement("button");
deleteBtn.textContent = "Delete";
deleteBtn.addEventListener("click", () => card.remove());

// Assemble the card
card.appendChild(heading);
card.appendChild(description);
card.appendChild(deleteBtn);

// Add to the page
document.querySelector("#cardContainer").appendChild(card);
```

### Activity: Build a To-Do List App ✅

Create a working to-do list where you can add and remove tasks:

```html
<!DOCTYPE html>
<html>
<body>
  <h1>My To-Do List</h1>
  <input type="text" id="taskInput" placeholder="Add a new task...">
  <button id="addBtn">Add Task</button>
  <ul id="taskList"></ul>

  <script>
    const input = document.querySelector("#taskInput");
    const addBtn = document.querySelector("#addBtn");
    const taskList = document.querySelector("#taskList");

    addBtn.addEventListener("click", () => {
      const taskText = input.value.trim();
      if (!taskText) return;

      // Create the list item
      const li = document.createElement("li");
      li.textContent = taskText;

      // Create a delete button
      const deleteBtn = document.createElement("button");
      deleteBtn.textContent = "✕";
      deleteBtn.style.marginLeft = "10px";
      deleteBtn.addEventListener("click", () => li.remove());

      li.appendChild(deleteBtn);
      taskList.appendChild(li);

      input.value = ""; // Clear the input
      input.focus();    // Ready for next task
    });

    // Also add task when pressing Enter
    input.addEventListener("keydown", (event) => {
      if (event.key === "Enter") addBtn.click();
    });
  </script>
</body>
</html>
```

**Challenge:** Add a "Mark as done" feature — clicking the task text should strike it through. Add a counter showing how many tasks are left.

### Key DOM Manipulation Methods

| Method | What it does |
|--------|-------------|
| `document.createElement(tag)` | Creates a new element |
| `parent.appendChild(child)` | Adds child at end of parent |
| `parent.insertBefore(new, ref)` | Inserts new before ref element |
| `parent.removeChild(child)` | Removes child from parent |
| `element.remove()` | Removes the element itself |
| `element.setAttribute(name, value)` | Sets an HTML attribute |

### What''s Next?
You can build and destroy elements like a pro. Next: controlling how things **look** with CSS classes and inline styles from JavaScript!'),

('dev-l10', 'CSS Classes and Styles with JS', 'developers', 'DOM', 'en', 'intermediate', 35, 150, 10,
'## CSS Classes and Styles with JS 🎨

You know how to change text and create elements — now let''s make your pages look dynamic! JavaScript can add, remove, and toggle CSS classes, and even apply inline styles directly. This is how dark mode, animated menus, and interactive UIs are built!

### classList: Your Styling Remote Control

Every DOM element has a `classList` property. It lets you manage CSS classes without touching the HTML:

```javascript
const box = document.querySelector(".box");

box.classList.add("highlighted");     // Add a class
box.classList.remove("highlighted");  // Remove a class
box.classList.toggle("dark");         // Add if missing, remove if present
box.classList.contains("active");     // Returns true or false
box.classList.replace("old", "new");  // Replace one class with another
```

The real power is in your CSS file. Define the styles there, then switch classes with JavaScript:

```css
/* In your CSS */
.hidden { display: none; }
.highlighted { background-color: yellow; border: 2px solid orange; }
.dark-mode { background: #1a1a1a; color: white; }
.shake { animation: shake 0.5s; }
```

```javascript
// In your JavaScript
document.querySelector("#toggleBtn").addEventListener("click", () => {
  document.body.classList.toggle("dark-mode");
});
```

With just one line of JavaScript, you switch between entire visual themes!

### The style Property

For quick, one-off style changes, you can use the `style` property directly:

```javascript
const title = document.querySelector("h1");

title.style.color = "red";
title.style.fontSize = "48px";
title.style.fontWeight = "bold";
title.style.backgroundColor = "lightyellow";
title.style.padding = "10px";
```

Note: CSS properties with hyphens become camelCase in JavaScript:
- `background-color` → `backgroundColor`
- `font-size` → `fontSize`
- `border-radius` → `borderRadius`
- `margin-top` → `marginTop`

**Tip:** Prefer classList + CSS over inline styles. It keeps your styling in one place and is easier to maintain!

### CSS Transitions and Animations

When you combine classList toggling with CSS transitions, you get smooth animations:

```css
.box {
  width: 100px;
  height: 100px;
  background: blue;
  transition: all 0.3s ease; /* Smooth transition */
}

.box.expanded {
  width: 200px;
  height: 200px;
  background: purple;
}
```

```javascript
const box = document.querySelector(".box");

box.addEventListener("click", () => {
  box.classList.toggle("expanded");
});
```

Click the box and it smoothly animates between states! CSS transitions handle the animation; JavaScript just switches the class.

### Computed Styles

You can read the current styles applied to an element (including from CSS files) with `getComputedStyle`:

```javascript
const box = document.querySelector(".box");
const styles = getComputedStyle(box);

console.log(styles.backgroundColor); // e.g., "rgb(0, 0, 255)"
console.log(styles.fontSize);        // e.g., "16px"
console.log(styles.display);         // e.g., "block"
```

This is useful for reading styles that were set by CSS, not by JavaScript.

### Building a Theme Switcher

Here is a practical example — a multi-theme switcher:

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    body { transition: background 0.3s, color 0.3s; }
    .theme-light { background: white; color: black; }
    .theme-dark { background: #1a1a1a; color: white; }
    .theme-ocean { background: #003366; color: #00ccff; }
    .theme-forest { background: #1a4a1a; color: #90ee90; }
    .btn { margin: 5px; padding: 10px 20px; cursor: pointer; border: none; border-radius: 5px; }
  </style>
</head>
<body class="theme-light">
  <h1>Theme Switcher</h1>
  <button class="btn" onclick="setTheme(''theme-light'')">Light</button>
  <button class="btn" onclick="setTheme(''theme-dark'')">Dark</button>
  <button class="btn" onclick="setTheme(''theme-ocean'')">Ocean</button>
  <button class="btn" onclick="setTheme(''theme-forest'')">Forest</button>

  <script>
    function setTheme(theme) {
      document.body.className = theme; // Replaces all classes
    }
  </script>
</body>
</html>
```

### Activity: Build a Card Flip Animation 🃏

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    .card {
      width: 200px; height: 120px; border: 2px solid #333;
      border-radius: 10px; cursor: pointer;
      display: flex; align-items: center; justify-content: center;
      font-size: 24px; transition: all 0.4s ease;
      background: white;
    }
    .card.flipped { background: #4CAF50; color: white; transform: rotateY(180deg); }
  </style>
</head>
<body>
  <p>Click the card to flip it!</p>
  <div class="card" id="card">🂠 Click me!</div>

  <script>
    const card = document.querySelector("#card");
    card.addEventListener("click", () => {
      card.classList.toggle("flipped");
      card.textContent = card.classList.contains("flipped") ? "🎉 Revealed!" : "🂠 Click me!";
    });
  </script>
</body>
</html>
```

**Challenge:** Create a grid of 9 cards. Clicking a card reveals a symbol (★, ♥, ♦, etc.). Cards with the same symbol are a matching pair — highlight matched pairs in green!

### classList vs style: When to Use What

| Use `classList` when... | Use `style` when... |
|------------------------|---------------------|
| You have defined CSS classes | You need a one-off dynamic value |
| You want smooth transitions | Setting a calculated value (e.g., `element.style.width = count + "px"`) |
| You want reusable styles | Quick prototyping |
| You want clean separation of concerns | The value can''t be known in CSS |

### What''s Next?
You can style anything dynamically. Next: **forms and user input** — the backbone of interactive web applications!'),

('dev-l11', 'Forms and User Input', 'developers', 'DOM', 'en', 'intermediate', 35, 150, 11,
'## Forms and User Input 📝

Forms are how users give information to websites — login pages, search bars, checkout forms, comment boxes. Understanding how to work with forms in JavaScript is one of the most essential web development skills. Let''s master it!

### HTML Form Elements

Here are the most common form elements you will work with:

```html
<!-- Text input -->
<input type="text" id="username" placeholder="Enter username">

<!-- Password input -->
<input type="password" id="password" placeholder="Enter password">

<!-- Number input -->
<input type="number" id="age" min="1" max="120">

<!-- Checkbox -->
<input type="checkbox" id="agree"> <label for="agree">I agree</label>

<!-- Radio buttons -->
<input type="radio" name="colour" value="red" id="red"> <label for="red">Red</label>
<input type="radio" name="colour" value="blue" id="blue"> <label for="blue">Blue</label>

<!-- Select / dropdown -->
<select id="country">
  <option value="uk">United Kingdom</option>
  <option value="us">United States</option>
</select>

<!-- Textarea -->
<textarea id="message" rows="4" placeholder="Your message..."></textarea>
```

### Getting Values from Inputs

Each form element has a `.value` property (except checkboxes and radios):

```javascript
const username = document.querySelector("#username").value;
const age = document.querySelector("#age").value; // Note: always a string!
const country = document.querySelector("#country").value;
const message = document.querySelector("#message").value;

// Checkbox: use .checked instead of .value
const agreed = document.querySelector("#agree").checked; // true or false

// Radio: find which is selected
const selectedColour = document.querySelector("input[name=''colour'']:checked");
if (selectedColour) {
  console.log(selectedColour.value); // "red" or "blue"
}
```

### The submit Event and preventDefault

When a form is submitted (button clicked or Enter pressed), the browser normally reloads the page. Stop this with `preventDefault()`:

```html
<form id="loginForm">
  <input type="text" id="username" placeholder="Username" required>
  <input type="password" id="password" placeholder="Password" required>
  <button type="submit">Log In</button>
</form>
```

```javascript
const form = document.querySelector("#loginForm");

form.addEventListener("submit", (event) => {
  event.preventDefault(); // Stop page reload!

  const username = document.querySelector("#username").value;
  const password = document.querySelector("#password").value;

  console.log("Login attempt:", username);
  // Now you can validate and process the data
});
```

### Form Validation

Always validate user input! Do not trust that users enter the right things.

```javascript
form.addEventListener("submit", (event) => {
  event.preventDefault();

  const username = document.querySelector("#username").value.trim();
  const password = document.querySelector("#password").value;
  const errorDiv = document.querySelector("#error");

  // Clear previous errors
  errorDiv.textContent = "";

  // Validate
  if (username.length < 3) {
    errorDiv.textContent = "Username must be at least 3 characters.";
    return; // Stop here
  }

  if (password.length < 8) {
    errorDiv.textContent = "Password must be at least 8 characters.";
    return;
  }

  // All good!
  errorDiv.textContent = "Logged in successfully!";
  errorDiv.style.color = "green";
});
```

The `.trim()` method removes extra spaces from the start and end of a string — very useful for cleaning input!

### Real-Time Validation

You can also validate as the user types, giving instant feedback:

```javascript
const emailInput = document.querySelector("#email");
const emailError = document.querySelector("#emailError");

emailInput.addEventListener("input", () => {
  const email = emailInput.value;

  if (email.includes("@") && email.includes(".")) {
    emailError.textContent = "✓ Valid email";
    emailError.style.color = "green";
  } else {
    emailError.textContent = "Please enter a valid email";
    emailError.style.color = "red";
  }
});
```

### Activity: Build a Registration Form 📋

Create a complete registration form with validation:

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    .error { color: red; font-size: 0.85em; }
    .success { color: green; }
    input { display: block; margin: 5px 0 2px; padding: 8px; width: 250px; }
    button { margin-top: 10px; padding: 10px 20px; background: #4CAF50; color: white; border: none; cursor: pointer; }
  </style>
</head>
<body>
  <h2>Create Account</h2>
  <form id="regForm">
    <label>Username:</label>
    <input type="text" id="username" placeholder="At least 3 characters">
    <span class="error" id="usernameError"></span>

    <label>Email:</label>
    <input type="email" id="email" placeholder="you@example.com">
    <span class="error" id="emailError"></span>

    <label>Password:</label>
    <input type="password" id="password" placeholder="At least 8 characters">
    <span class="error" id="passwordError"></span>

    <button type="submit">Create Account</button>
    <p id="successMsg"></p>
  </form>

  <script>
    document.querySelector("#regForm").addEventListener("submit", (e) => {
      e.preventDefault();
      let valid = true;

      const username = document.querySelector("#username").value.trim();
      const email = document.querySelector("#email").value.trim();
      const password = document.querySelector("#password").value;

      document.querySelector("#usernameError").textContent =
        username.length < 3 ? "Username too short!" : "";
      if (username.length < 3) valid = false;

      document.querySelector("#emailError").textContent =
        !email.includes("@") ? "Invalid email!" : "";
      if (!email.includes("@")) valid = false;

      document.querySelector("#passwordError").textContent =
        password.length < 8 ? "Password too short!" : "";
      if (password.length < 8) valid = false;

      if (valid) {
        document.querySelector("#successMsg").textContent = "Account created! Welcome, " + username + "!";
        document.querySelector("#successMsg").style.color = "green";
      }
    });
  </script>
</body>
</html>
```

**Challenge:** Add a "Confirm Password" field that checks whether both passwords match. Add a password strength indicator (weak/medium/strong).

### What''s Next?
You are now a DOM master! Next we dive into JavaScript itself with a deep dive into **functions** — the building blocks of all programmes!'),

('dev-l12', 'Functions Deep Dive', 'developers', 'Functions', 'en', 'intermediate', 35, 150, 12,
'## Functions Deep Dive 🔧

Functions are one of the most important concepts in all of programming. You have been using them already — now it is time to truly understand how they work, how to write clean ones, and how to use modern JavaScript function syntax like arrow functions.

### What Is a Function?

A function is a reusable block of code that does a specific job. Instead of writing the same code in multiple places, you put it in a function and call it whenever you need it.

```javascript
// Without functions — repetitive!
console.log("Hello, Alice!");
console.log("Alice has joined the chat.");

console.log("Hello, Ben!");
console.log("Ben has joined the chat.");

// With a function — clean and reusable!
function greet(name) {
  console.log("Hello, " + name + "!");
  console.log(name + " has joined the chat.");
}

greet("Alice");
greet("Ben");
greet("Charlie"); // Easy to add more!
```

### Parameters and Arguments

**Parameters** are the variable names listed in the function definition. **Arguments** are the actual values passed when calling the function.

```javascript
// name and age are parameters
function introduce(name, age) {
  console.log("I am " + name + " and I am " + age + " years old.");
}

// "Jordan" and 12 are arguments
introduce("Jordan", 12);
introduce("Sam", 14);
```

#### Default Parameters
You can set default values that are used when an argument is missing:

```javascript
function greet(name = "stranger", greeting = "Hello") {
  console.log(greeting + ", " + name + "!");
}

greet("Alice", "Hey");   // Hey, Alice!
greet("Bob");            // Hello, Bob!
greet();                 // Hello, stranger!
```

### Return Values

Functions can send a value back to wherever they were called from, using `return`:

```javascript
function add(a, b) {
  return a + b;
}

const result = add(10, 5);
console.log(result); // 15

// You can use the return value directly
console.log(add(3, 7) * 2); // 20
```

`return` immediately exits the function. Any code after it in the function will not run:

```javascript
function checkAge(age) {
  if (age < 13) {
    return "Too young for this app.";
  }
  if (age > 120) {
    return "That age seems unlikely!";
  }
  return "Welcome!"; // Only reached if age is 13-120
}
```

### Scope: Where Variables Live

Variables declared inside a function only exist inside that function — this is called **local scope**:

```javascript
function calculateScore() {
  const bonus = 50; // Only exists inside this function
  return 100 + bonus;
}

console.log(calculateScore()); // 150
console.log(bonus); // Error! bonus is not defined here
```

Variables outside all functions are in the **global scope** and can be accessed anywhere:

```javascript
const playerName = "Alex"; // Global

function showPlayer() {
  console.log(playerName); // Can access global variable
}
```

### Arrow Functions

Arrow functions are a modern, shorter way to write functions:

```javascript
// Traditional function
function square(n) {
  return n * n;
}

// Arrow function — same thing!
const square = (n) => {
  return n * n;
};

// Shortest form: single expression, implicit return
const square = (n) => n * n;

// No parameters
const sayHi = () => console.log("Hi!");

// One parameter — parentheses optional
const double = n => n * 2;
```

Arrow functions are especially useful as callbacks (functions passed to other functions):

```javascript
const numbers = [1, 2, 3, 4, 5];

// Old way
const doubled = numbers.map(function(n) { return n * 2; });

// Arrow function way — much cleaner!
const doubled = numbers.map(n => n * 2);
```

### Higher-Order Functions

A **higher-order function** is a function that takes another function as an argument, or returns a function. This is a very powerful pattern:

```javascript
function repeat(action, times) {
  for (let i = 0; i < times; i++) {
    action(i);
  }
}

repeat((i) => console.log("Round " + (i + 1)), 5);
// Prints: Round 1, Round 2, Round 3, Round 4, Round 5
```

### Activity: Build a Calculator Library 🔢

Create a set of calculator functions:

```javascript
// Basic operations
const add = (a, b) => a + b;
const subtract = (a, b) => a - b;
const multiply = (a, b) => a * b;
const divide = (a, b) => {
  if (b === 0) return "Cannot divide by zero!";
  return a / b;
};

// More complex functions
const power = (base, exp) => Math.pow(base, exp);
const average = (...numbers) => numbers.reduce(add, 0) / numbers.length;
const clamp = (value, min, max) => Math.min(Math.max(value, min), max);

// Test them!
console.log(add(10, 5));           // 15
console.log(average(2, 4, 6, 8)); // 5
console.log(clamp(150, 0, 100));  // 100

// Build a simple calculator
function calculate(a, operator, b) {
  switch (operator) {
    case "+": return add(a, b);
    case "-": return subtract(a, b);
    case "*": return multiply(a, b);
    case "/": return divide(a, b);
    default: return "Unknown operator";
  }
}

console.log(calculate(10, "+", 5));  // 15
console.log(calculate(10, "/", 0));  // Cannot divide by zero!
```

**Challenge:** Write a function called `compose(f, g)` that takes two functions and returns a new function that applies both — first `g`, then `f`. Test it with `compose(double, square)` — what does it do?

### What''s Next?
Functions are now in your toolkit! Next: **Arrays** — JavaScript''s way of storing and working with lists of data!'),

('dev-l13', 'Arrays: Storing Lists of Data', 'developers', 'Arrays', 'en', 'intermediate', 35, 150, 13,
'## Arrays: Storing Lists of Data 📋

Imagine storing 100 usernames in 100 separate variables — what a nightmare! Arrays solve this by letting you store as many items as you like in a single, ordered list. Arrays are one of the most-used data structures in all of programming.

### Creating Arrays

```javascript
// Array of strings
const fruits = ["apple", "banana", "cherry"];

// Array of numbers
const scores = [98, 75, 82, 91, 68];

// Mixed types (allowed but uncommon)
const mixed = [42, "hello", true, null];

// Empty array
const emptyList = [];

// Array with 5 items, all undefined
const fiveSlots = new Array(5);
```

### Accessing Items

Arrays are **zero-indexed** — the first item is at position 0:

```javascript
const colours = ["red", "green", "blue"];

console.log(colours[0]); // "red"
console.log(colours[1]); // "green"
console.log(colours[2]); // "blue"
console.log(colours[3]); // undefined (does not exist)

// Last item
console.log(colours[colours.length - 1]); // "blue"
```

### Adding and Removing Items

```javascript
const animals = ["cat", "dog"];

// Add to the END
animals.push("rabbit");      // ["cat", "dog", "rabbit"]

// Remove from the END
animals.pop();               // ["cat", "dog"] — returns "rabbit"

// Add to the START
animals.unshift("fish");     // ["fish", "cat", "dog"]

// Remove from the START
animals.shift();             // ["cat", "dog"] — returns "fish"

// Add/remove anywhere with splice
animals.splice(1, 0, "bird"); // Insert "bird" at index 1
// ["cat", "bird", "dog"]
```

### Searching Arrays

```javascript
const fruits = ["apple", "banana", "cherry", "apple"];

fruits.includes("banana");          // true
fruits.indexOf("apple");            // 0 (first occurrence)
fruits.lastIndexOf("apple");        // 3 (last occurrence)
fruits.indexOf("mango");            // -1 (not found)

// Find an item matching a condition
const numbers = [5, 12, 8, 130, 44];
const found = numbers.find(n => n > 10);         // 12 (first match)
const foundIndex = numbers.findIndex(n => n > 10); // 1
```

### The Power Three: map, filter, reduce

These three methods transform arrays in powerful ways and are used in virtually every JavaScript project.

#### map — Transform each item
```javascript
const numbers = [1, 2, 3, 4, 5];

// Create a new array by transforming each item
const doubled = numbers.map(n => n * 2);
// [2, 4, 6, 8, 10]

const names = ["alice", "bob", "charlie"];
const capitalised = names.map(name => name[0].toUpperCase() + name.slice(1));
// ["Alice", "Bob", "Charlie"]
```

#### filter — Keep only matching items
```javascript
const scores = [45, 92, 67, 78, 55, 89, 34];

// Keep only passing scores (>= 60)
const passing = scores.filter(score => score >= 60);
// [92, 67, 78, 89]

// Keep only even numbers
const evens = [1,2,3,4,5,6].filter(n => n % 2 === 0);
// [2, 4, 6]
```

#### reduce — Combine everything into one value
```javascript
const prices = [9.99, 4.50, 14.00, 2.25];

// Add all prices together
const total = prices.reduce((sum, price) => sum + price, 0);
// 30.74

// Find the highest score
const scores = [45, 92, 67, 89];
const highest = scores.reduce((max, score) => Math.max(max, score), 0);
// 92
```

### Chaining Methods

The real magic happens when you chain these methods:

```javascript
const students = [
  { name: "Alice", score: 92 },
  { name: "Bob", score: 45 },
  { name: "Charlie", score: 78 },
  { name: "Diana", score: 55 },
  { name: "Eve", score: 88 }
];

// Get names of students who passed (score >= 60), sorted alphabetically
const passingNames = students
  .filter(student => student.score >= 60)
  .map(student => student.name)
  .sort();

console.log(passingNames); // ["Alice", "Charlie", "Eve"]
```

### Other Useful Array Methods

```javascript
const nums = [3, 1, 4, 1, 5, 9, 2, 6];

nums.sort((a, b) => a - b);  // [1, 1, 2, 3, 4, 5, 6, 9] ascending
nums.reverse();               // Reverse the array in place
nums.slice(1, 4);             // [1, 2, 3] — new array, no modification
nums.join(", ");              // "3, 1, 4, 1, 5, 9, 2, 6" — makes a string

// Spreading arrays
const arr1 = [1, 2, 3];
const arr2 = [4, 5, 6];
const combined = [...arr1, ...arr2]; // [1, 2, 3, 4, 5, 6]
```

### Activity: Student Grade Analyser 📊

```javascript
const students = [
  { name: "Alice", scores: [88, 92, 95, 79] },
  { name: "Bob", scores: [55, 62, 48, 70] },
  { name: "Charlie", scores: [90, 85, 92, 88] },
  { name: "Diana", scores: [72, 68, 75, 80] },
  { name: "Eve", scores: [45, 52, 60, 55] }
];

// Calculate average score for each student
const withAverages = students.map(student => ({
  name: student.name,
  average: student.scores.reduce((sum, s) => sum + s, 0) / student.scores.length
}));

// Get only passing students (average >= 65)
const passing = withAverages.filter(s => s.average >= 65);

// Sort by average descending
passing.sort((a, b) => b.average - a.average);

console.log("Passing students (highest first):");
passing.forEach(s => console.log(s.name + ": " + s.average.toFixed(1)));
```

**Challenge:** Add a function that gives each student a grade (A, B, C, D, F) based on their average. Display a report card for the class.

### What''s Next?
Arrays are for lists of similar items. Next: **Objects** — for storing structured, real-world data with named properties!'),

('dev-l14', 'Objects: Real-World Data Structures', 'developers', 'Objects', 'en', 'intermediate', 35, 150, 14,
'## Objects: Real-World Data Structures 🗂️

Arrays are great for lists. But what about more complex data — a user with a name, age, email, and avatar? Objects let you group related data together with meaningful labels. They are the backbone of JavaScript programming.

### Creating Objects

An object is a collection of **key-value pairs**, also called **properties**:

```javascript
// Object literal — the most common way
const person = {
  name: "Alex",
  age: 13,
  email: "alex@example.com",
  isStudent: true
};

// Empty object
const emptyObj = {};
```

### Accessing Properties

Two ways to get values from an object:

```javascript
const car = {
  make: "Toyota",
  model: "Corolla",
  year: 2022,
  colour: "blue"
};

// Dot notation (preferred when key name is known)
console.log(car.make);   // "Toyota"
console.log(car.year);   // 2022

// Bracket notation (required when key is dynamic or has special characters)
const property = "model";
console.log(car[property]); // "Corolla"
console.log(car["colour"]); // "blue"
```

### Modifying Objects

Objects are mutable — you can add, change, or delete properties:

```javascript
const user = { name: "Sam", level: 1 };

// Change a property
user.level = 5;

// Add a new property
user.xp = 2500;
user.badge = "Gold";

// Delete a property
delete user.badge;

console.log(user); // { name: "Sam", level: 5, xp: 2500 }
```

### Methods: Functions Inside Objects

Objects can contain functions — these are called **methods**:

```javascript
const calculator = {
  value: 0,

  add(n) {
    this.value += n;
    return this; // Return this for chaining
  },

  subtract(n) {
    this.value -= n;
    return this;
  },

  reset() {
    this.value = 0;
    return this;
  },

  result() {
    return this.value;
  }
};

// Chain method calls!
const answer = calculator.add(10).add(5).subtract(3).result();
console.log(answer); // 12
```

The `this` keyword refers to the object the method belongs to.

### Destructuring

Destructuring lets you pull properties out of an object into variables — much cleaner than accessing them one by one:

```javascript
const user = {
  name: "Jordan",
  age: 12,
  city: "London",
  score: 850
};

// Old way
const name = user.name;
const age = user.age;

// Destructuring — much cleaner!
const { name, age, city } = user;
console.log(name, age, city); // Jordan 12 London

// Rename while destructuring
const { score: userScore } = user;
console.log(userScore); // 850

// Default values
const { country = "Unknown" } = user;
console.log(country); // "Unknown" (not in object)
```

### Spread and Rest with Objects

```javascript
const defaults = { theme: "light", language: "en", fontSize: 16 };
const userPrefs = { theme: "dark", fontSize: 18 };

// Merge objects (later values override earlier ones)
const settings = { ...defaults, ...userPrefs };
// { theme: "dark", language: "en", fontSize: 18 }
```

### Arrays of Objects — The Real World

Most real data is an array of objects:

```javascript
const users = [
  { id: 1, name: "Alice", role: "admin", active: true },
  { id: 2, name: "Bob", role: "user", active: false },
  { id: 3, name: "Charlie", role: "user", active: true }
];

// Find a user by id
const alice = users.find(user => user.id === 1);
console.log(alice.name); // "Alice"

// Get all active users
const activeUsers = users.filter(user => user.active);

// Get all usernames
const names = users.map(user => user.name);
// ["Alice", "Bob", "Charlie"]
```

### Activity: Build a Game Character System 🎮

```javascript
// Constructor function for creating characters
function createCharacter(name, class_, level) {
  return {
    name,
    class: class_,
    level,
    health: level * 100,
    xp: 0,
    inventory: [],

    attack() {
      const damage = Math.floor(Math.random() * 20) + this.level * 5;
      console.log(this.name + " attacks for " + damage + " damage!");
      return damage;
    },

    gainXP(amount) {
      this.xp += amount;
      if (this.xp >= this.level * 100) {
        this.level++;
        this.health = this.level * 100;
        this.xp = 0;
        console.log(this.name + " levelled up to level " + this.level + "!");
      }
    },

    pickUp(item) {
      this.inventory.push(item);
      console.log(this.name + " picked up " + item);
    },

    status() {
      return this.name + " (Level " + this.level + " " + this.class + ") HP: " + this.health + " XP: " + this.xp;
    }
  };
}

const hero = createCharacter("Aria", "Mage", 3);
hero.pickUp("Magic Staff");
hero.gainXP(250);
hero.attack();
console.log(hero.status());
```

**Challenge:** Create a `battle(character1, character2)` function that simulates a fight between two characters, each attacking alternately until one reaches 0 HP.

### What''s Next?
Objects model real-world data perfectly. Next: **Loops** — the engine that powers repetitive tasks across arrays, objects, and more!'),

('dev-l15', 'Loops: For, While, forEach', 'developers', 'Loops', 'en', 'intermediate', 35, 150, 15,
'## Loops: For, While, forEach 🔄

Loops are what make computers powerful. Instead of writing the same code 100 times, you write it once inside a loop and let the computer repeat it. JavaScript has several different types of loops, each suited to different situations.

### The Classic for Loop

The `for` loop is the most traditional loop. It has three parts: initialisation, condition, and update:

```javascript
for (let i = 0; i < 5; i++) {
  console.log("Count: " + i);
}
// Count: 0, Count: 1, Count: 2, Count: 3, Count: 4
```

Breaking it down:
- `let i = 0` — start with i at 0
- `i < 5` — keep looping while i is less than 5
- `i++` — add 1 to i after each loop

#### Counting backwards
```javascript
for (let i = 10; i >= 0; i--) {
  console.log(i);
}
console.log("Blast off! 🚀");
```

#### Looping through an array
```javascript
const fruits = ["apple", "banana", "cherry"];

for (let i = 0; i < fruits.length; i++) {
  console.log(i + ": " + fruits[i]);
}
// 0: apple
// 1: banana
// 2: cherry
```

### The while Loop

`while` loops keep running as long as a condition is true. Use them when you do not know in advance how many times to loop:

```javascript
let password = "";
const correctPassword = "secret123";

while (password !== correctPassword) {
  password = prompt("Enter the password:");
}
console.log("Access granted!");
```

```javascript
// Random number until we get a 6 (like rolling a die)
let roll = 0;
let attempts = 0;

while (roll !== 6) {
  roll = Math.floor(Math.random() * 6) + 1;
  attempts++;
  console.log("Rolled: " + roll);
}
console.log("Got a 6 after " + attempts + " attempts!");
```

**Warning:** Make sure your while loop condition can eventually become false — otherwise you create an infinite loop that crashes your programme!

### do...while

Similar to while, but always runs at least once:

```javascript
let count = 0;

do {
  console.log("This always runs at least once!");
  count++;
} while (count < 0); // Condition is false, but we still ran once
```

### for...of — The Modern Array Loop

`for...of` is the cleanest way to loop through arrays and other iterables:

```javascript
const colours = ["red", "green", "blue"];

for (const colour of colours) {
  console.log(colour);
}
// red, green, blue

// Works with strings too!
for (const char of "hello") {
  console.log(char);
}
// h, e, l, l, o
```

### for...in — Looping Through Object Keys

`for...in` loops through the **keys** of an object:

```javascript
const person = { name: "Alice", age: 13, city: "London" };

for (const key in person) {
  console.log(key + ": " + person[key]);
}
// name: Alice
// age: 13
// city: London
```

### forEach — The Array Method Loop

Arrays have a built-in `forEach` method that runs a function for each item:

```javascript
const numbers = [1, 2, 3, 4, 5];

numbers.forEach(number => {
  console.log(number * number);
});
// 1, 4, 9, 16, 25

// With index
numbers.forEach((number, index) => {
  console.log("Item " + index + ": " + number);
});
```

### break and continue

`break` exits the loop immediately. `continue` skips the rest of the current iteration and moves to the next:

```javascript
// break — stop when we find what we want
const names = ["Alice", "Bob", "Charlie", "Diana"];
for (const name of names) {
  if (name === "Charlie") {
    console.log("Found Charlie!");
    break; // Stop looking
  }
  console.log("Checking: " + name);
}

// continue — skip certain items
for (let i = 0; i <= 10; i++) {
  if (i % 2 === 0) continue; // Skip even numbers
  console.log(i); // Only prints odd numbers: 1, 3, 5, 7, 9
}
```

### Choosing the Right Loop

| Loop | Best for |
|------|---------|
| `for` | When you know the count in advance |
| `while` | When you loop until a condition changes |
| `for...of` | Looping through array items |
| `for...in` | Looping through object keys |
| `forEach` | Array iteration with a callback function |

### Activity: Multiplication Table Generator 📊

```javascript
function multiplicationTable(num, upTo = 12) {
  console.log("=== " + num + "x Table ===");
  for (let i = 1; i <= upTo; i++) {
    const result = num * i;
    const padding = result < 10 ? " " : "";
    console.log(num + " x " + i + " = " + padding + result);
  }
}

multiplicationTable(7);

// Bonus: print a full times table grid
console.log("\n=== Full Times Table ===");
for (let row = 1; row <= 10; row++) {
  let line = "";
  for (let col = 1; col <= 10; col++) {
    const product = row * col;
    line += (product < 10 ? " " : "") + product + " ";
  }
  console.log(line);
}
```

**Challenge:** Use a while loop to find all prime numbers up to 100. Hint: a prime number is only divisible by 1 and itself.

### What''s Next?
Loops done! Next: **Conditionals and Logic** — making your code make decisions!'),

('dev-l16', 'Conditionals and Logic', 'developers', 'Logic', 'en', 'intermediate', 35, 150, 16,
'## Conditionals and Logic 🧠

Programming is about making decisions. Should we show this message? Is the user logged in? Did the player win? Conditionals are how your code chooses one path over another. Combined with logical operators, they make your programmes truly intelligent.

### if / else / else if

The foundation of all decision-making in JavaScript:

```javascript
const score = 78;

if (score >= 90) {
  console.log("Grade: A — Excellent!");
} else if (score >= 80) {
  console.log("Grade: B — Great work!");
} else if (score >= 70) {
  console.log("Grade: C — Good effort!");
} else if (score >= 60) {
  console.log("Grade: D — You passed.");
} else {
  console.log("Grade: F — Please try again.");
}
```

### Comparison Operators

```javascript
const a = 10;
const b = "10";

console.log(a === 10);   // true  (strict: same type AND value)
console.log(a == b);     // true  (loose: just value, ignores type) — avoid this!
console.log(a !== b);    // true  (strict not-equal)
console.log(a > 5);      // true
console.log(a <= 10);    // true
console.log(a < b);      // false
```

**Always use `===` and `!==`** (strict equality). The loose operators `==` and `!=` cause subtle bugs.

### Logical Operators

Combine multiple conditions:

```javascript
const age = 14;
const hasPermission = true;

// AND — both must be true
if (age >= 13 && hasPermission) {
  console.log("Access allowed!");
}

// OR — at least one must be true
if (age < 5 || age > 100) {
  console.log("That age seems unusual...");
}

// NOT — inverts true/false
const isBlocked = false;
if (!isBlocked) {
  console.log("User is not blocked.");
}
```

### Truthy and Falsy

In JavaScript, some values count as `false` in a condition even if they are not literally `false`:

**Falsy values:** `false`, `0`, `""` (empty string), `null`, `undefined`, `NaN`
**Everything else is truthy** — including `[]`, `{}`, `"0"`, `-1`

```javascript
const username = "";

if (!username) {
  console.log("Please enter a username!"); // Runs because "" is falsy
}

const items = [1, 2, 3];
if (items.length) {
  console.log("There are items!"); // Runs because 3 is truthy
}
```

### The switch Statement

`switch` is cleaner than many `else if` blocks when comparing one value to many options:

```javascript
const day = "Wednesday";

switch (day) {
  case "Monday":
  case "Tuesday":
  case "Wednesday":
  case "Thursday":
  case "Friday":
    console.log("It''s a weekday!");
    break;
  case "Saturday":
  case "Sunday":
    console.log("It''s the weekend!");
    break;
  default:
    console.log("Unknown day.");
}
```

Always include `break` at the end of each case (or it "falls through" to the next case — usually a bug).

### The Ternary Operator

A compact one-line alternative to simple if/else:

```javascript
// if/else version
let message;
if (score >= 60) {
  message = "Passed";
} else {
  message = "Failed";
}

// Ternary version — same result
const message = score >= 60 ? "Passed" : "Failed";

// Nested ternary (use sparingly — hard to read)
const grade = score >= 90 ? "A" : score >= 80 ? "B" : score >= 70 ? "C" : "D";
```

### Short-Circuit Evaluation

Logical operators can be used as shortcuts:

```javascript
// && returns the first falsy value, or the last value if all truthy
const name = username && username.toUpperCase(); // Only uppercase if username exists

// || returns the first truthy value
const displayName = username || "Anonymous"; // Use "Anonymous" if username is empty

// ?? (nullish coalescing) — only falls back for null/undefined
const port = userPort ?? 3000; // Use 3000 only if userPort is null or undefined
```

### Activity: Build a Quiz Game 🎮

```javascript
const questions = [
  { question: "What is 7 × 8?", answer: "56" },
  { question: "What is the capital of France?", answer: "Paris" },
  { question: "What language runs in browsers?", answer: "JavaScript" },
  { question: "How many sides does a hexagon have?", answer: "6" }
];

let score = 0;
let streak = 0;

questions.forEach((q, index) => {
  const userAnswer = prompt("Q" + (index + 1) + ": " + q.question);

  if (userAnswer === null) {
    console.log("Quiz abandoned.");
    return;
  }

  const correct = userAnswer.trim().toLowerCase() === q.answer.toLowerCase();

  if (correct) {
    score++;
    streak++;
    const bonus = streak >= 3 ? " (STREAK BONUS! 🔥)" : "";
    console.log("✓ Correct!" + bonus);
  } else {
    streak = 0;
    console.log("✗ Wrong. The answer was: " + q.answer);
  }
});

const percentage = Math.round((score / questions.length) * 100);
const grade = percentage >= 90 ? "A" : percentage >= 75 ? "B" : percentage >= 60 ? "C" : "F";

console.log("\n=== Results ===");
console.log("Score: " + score + "/" + questions.length + " (" + percentage + "%)");
console.log("Grade: " + grade);
```

**Challenge:** Add difficulty levels (easy/medium/hard) with different question pools. Award bonus points for answering quickly (use `Date.now()` to measure time).

### What''s Next?
Your code can now make smart decisions! Next: **Error Handling** — what to do when things go wrong!'),

('dev-l17', 'Error Handling: try/catch/finally', 'developers', 'Errors', 'en', 'intermediate', 35, 150, 17,
'## Error Handling: try/catch/finally 🛡️

Things go wrong. Network connections drop, users enter unexpected values, APIs return strange data. Professional developers do not ignore errors — they handle them gracefully. In this lesson, you will learn how to make your programmes resilient!

### What Is an Error?

When JavaScript encounters something it cannot handle, it **throws an error** and stops running. You have probably seen these:
- `TypeError: Cannot read property of undefined`
- `ReferenceError: username is not defined`
- `SyntaxError: Unexpected token`
- `RangeError: Maximum call stack size exceeded`

Without error handling, these crash your programme. With error handling, you can catch them and respond intelligently.

### try/catch

Wrap risky code in a `try` block. If an error occurs, execution jumps to the `catch` block:

```javascript
try {
  // Code that might throw an error
  const data = JSON.parse("this is not valid JSON");
  console.log(data);
} catch (error) {
  // This runs if anything in try throws an error
  console.log("Caught an error:", error.message);
}

console.log("Programme continues!"); // This still runs
```

Without try/catch, `JSON.parse` with invalid JSON would crash the programme. With it, we catch the error and carry on.

### The Error Object

The `error` parameter in `catch` is an Error object with useful properties:

```javascript
try {
  undefinedFunction();
} catch (error) {
  console.log(error.name);    // "ReferenceError"
  console.log(error.message); // "undefinedFunction is not defined"
  console.log(error.stack);   // Full stack trace (where the error happened)
}
```

### finally — Always Runs

The `finally` block runs whether an error occurred or not. Perfect for cleanup code:

```javascript
function loadData() {
  console.log("Starting to load...");

  try {
    // Simulate an operation that might fail
    const result = riskyOperation();
    console.log("Success:", result);
  } catch (error) {
    console.log("Error:", error.message);
  } finally {
    console.log("Cleanup complete."); // Always runs
    hideLoadingSpinner(); // Always hide the spinner
  }
}
```

### Throwing Custom Errors

You can throw your own errors using `throw`:

```javascript
function divide(a, b) {
  if (typeof a !== "number" || typeof b !== "number") {
    throw new TypeError("Both arguments must be numbers");
  }
  if (b === 0) {
    throw new RangeError("Cannot divide by zero");
  }
  return a / b;
}

try {
  console.log(divide(10, 2));   // 5
  console.log(divide(10, 0));   // Throws!
} catch (error) {
  console.log(error.name + ": " + error.message);
}
```

### Custom Error Classes

For more sophisticated applications, create custom error types:

```javascript
class ValidationError extends Error {
  constructor(message, field) {
    super(message);
    this.name = "ValidationError";
    this.field = field;
  }
}

class NetworkError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.name = "NetworkError";
    this.statusCode = statusCode;
  }
}

function validateUser(user) {
  if (!user.name) {
    throw new ValidationError("Name is required", "name");
  }
  if (!user.email.includes("@")) {
    throw new ValidationError("Invalid email address", "email");
  }
}

try {
  validateUser({ name: "", email: "notanemail" });
} catch (error) {
  if (error instanceof ValidationError) {
    console.log("Validation failed on field: " + error.field);
    console.log("Message: " + error.message);
  } else {
    console.log("Unexpected error:", error);
  }
}
```

### Error Handling Patterns

#### Graceful degradation
```javascript
function getUserAvatar(user) {
  try {
    return user.profile.avatar.url;
  } catch {
    return "/images/default-avatar.png"; // Fall back to default
  }
}
```

#### Safe JSON parsing
```javascript
function safeParseJSON(jsonString) {
  try {
    return { success: true, data: JSON.parse(jsonString) };
  } catch (error) {
    return { success: false, error: error.message };
  }
}

const result = safeParseJSON("invalid json");
if (!result.success) {
  console.log("Failed to parse:", result.error);
}
```

### Activity: Build a Robust Calculator 🔢

```javascript
class CalculatorError extends Error {
  constructor(message, type) {
    super(message);
    this.name = "CalculatorError";
    this.type = type;
  }
}

function calculate(input) {
  try {
    // Validate input
    if (typeof input !== "string" || !input.trim()) {
      throw new CalculatorError("Input must be a non-empty string", "INVALID_INPUT");
    }

    // Parse the expression "number operator number"
    const parts = input.trim().split(" ");
    if (parts.length !== 3) {
      throw new CalculatorError("Format: number operator number (e.g. '10 + 5')", "INVALID_FORMAT");
    }

    const [aStr, operator, bStr] = parts;
    const a = parseFloat(aStr);
    const b = parseFloat(bStr);

    if (isNaN(a) || isNaN(b)) {
      throw new CalculatorError("Both values must be valid numbers", "INVALID_NUMBER");
    }

    switch (operator) {
      case "+": return a + b;
      case "-": return a - b;
      case "*": return a * b;
      case "/":
        if (b === 0) throw new CalculatorError("Division by zero is not allowed", "DIVISION_BY_ZERO");
        return a / b;
      default:
        throw new CalculatorError("Unknown operator: " + operator + ". Use +, -, *, /", "UNKNOWN_OPERATOR");
    }
  } catch (error) {
    if (error instanceof CalculatorError) {
      return "Error [" + error.type + "]: " + error.message;
    }
    return "Unexpected error: " + error.message;
  }
}

console.log(calculate("10 + 5"));     // 15
console.log(calculate("10 / 0"));     // Error [DIVISION_BY_ZERO]
console.log(calculate("hello + 5"));  // Error [INVALID_NUMBER]
console.log(calculate("10 % 3"));     // Error [UNKNOWN_OPERATOR]
```

**Challenge:** Add a `history` array that records all calculations (successful and failed). Add a `showHistory()` function that prints all past calculations with their results.

### What''s Next?
Your code now handles failure gracefully! Next: **the Fetch API** — loading data from the internet in JavaScript!'),

('dev-l18', 'Fetch API: Getting Data from the Web', 'developers', 'Async', 'en', 'intermediate', 35, 150, 18,
'## Fetch API: Getting Data from the Web 🌐

Every time you scroll Instagram, check the weather, or search Google, JavaScript is fetching data from a server. The **Fetch API** is the modern way to make these network requests directly from JavaScript in the browser. Let''s master it!

### What Is the Fetch API?

The `fetch()` function lets you request data from a URL and receive the response. It is built into all modern browsers — no libraries needed!

```javascript
fetch("https://api.example.com/data")
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.log("Error:", error));
```

But `fetch` is **asynchronous** — it does not wait for the data before moving to the next line. It works in the background and uses **Promises** to tell you when it is done.

### Understanding Promises

A Promise is an object that represents a value that is not available yet but will be in the future:

```javascript
const promise = fetch("https://api.github.com/users/octocat");

// A Promise has three states:
// pending  — waiting for the data
// fulfilled — data arrived!
// rejected  — something went wrong

promise
  .then(response => {
    // This runs when the fetch succeeds
    console.log("Got response:", response.status);
    return response.json(); // Returns another promise!
  })
  .then(data => {
    // This runs after .json() finishes
    console.log("User:", data.name);
  })
  .catch(error => {
    // This runs if ANY step fails
    console.log("Something went wrong:", error.message);
  });
```

### The Response Object

`fetch` gives you a `Response` object first. You need to parse it to get the actual data:

```javascript
fetch("https://api.github.com/users/octocat")
  .then(response => {
    console.log(response.ok);     // true if status 200-299
    console.log(response.status); // 200, 404, 500, etc.
    console.log(response.url);    // The URL that was fetched

    if (!response.ok) {
      throw new Error("HTTP error! Status: " + response.status);
    }

    return response.json(); // Parse body as JSON
  })
  .then(data => console.log(data));
```

Common response parsing methods:
- `response.json()` — parse as JSON (most common for APIs)
- `response.text()` — parse as plain text
- `response.blob()` — parse as binary data (images, files)

### Fetching from a Real API

Let''s fetch real data from the GitHub API:

```javascript
function getUserInfo(username) {
  fetch("https://api.github.com/users/" + username)
    .then(response => {
      if (!response.ok) {
        throw new Error("User not found!");
      }
      return response.json();
    })
    .then(user => {
      console.log("Name:", user.name);
      console.log("Bio:", user.bio);
      console.log("Public repos:", user.public_repos);
      console.log("Followers:", user.followers);
    })
    .catch(error => {
      console.log("Error:", error.message);
    });
}

getUserInfo("torvalds"); // Linus Torvalds — creator of Linux!
```

### Chaining .then() Calls

You can chain transformations:

```javascript
fetch("https://jsonplaceholder.typicode.com/posts")
  .then(response => response.json())
  .then(posts => posts.filter(post => post.userId === 1)) // Only user 1''s posts
  .then(posts => posts.map(post => ({ id: post.id, title: post.title }))) // Simplify
  .then(posts => {
    posts.forEach(post => console.log(post.id + ": " + post.title));
  })
  .catch(error => console.log("Error:", error));
```

### Making POST Requests

`fetch` can also send data to a server:

```javascript
fetch("https://jsonplaceholder.typicode.com/posts", {
  method: "POST",
  headers: {
    "Content-Type": "application/json"
  },
  body: JSON.stringify({
    title: "My New Post",
    body: "This is the content",
    userId: 1
  })
})
  .then(response => response.json())
  .then(data => console.log("Created post with id:", data.id))
  .catch(error => console.log("Error:", error));
```

### Activity: Build a Country Explorer 🌍

```html
<!DOCTYPE html>
<html>
<body>
  <h1>Country Explorer 🌍</h1>
  <input type="text" id="countryInput" placeholder="Enter a country name...">
  <button id="searchBtn">Search</button>
  <div id="result"></div>

  <script>
    document.querySelector("#searchBtn").addEventListener("click", () => {
      const country = document.querySelector("#countryInput").value.trim();
      const resultDiv = document.querySelector("#result");

      if (!country) {
        resultDiv.textContent = "Please enter a country name.";
        return;
      }

      resultDiv.textContent = "Loading...";

      fetch("https://restcountries.com/v3.1/name/" + encodeURIComponent(country))
        .then(response => {
          if (!response.ok) throw new Error("Country not found!");
          return response.json();
        })
        .then(data => {
          const c = data[0];
          resultDiv.innerHTML = `
            <h2>${c.name.common} ${c.flag}</h2>
            <p><strong>Capital:</strong> ${c.capital?.[0] ?? "N/A"}</p>
            <p><strong>Population:</strong> ${c.population.toLocaleString()}</p>
            <p><strong>Region:</strong> ${c.region}</p>
            <p><strong>Languages:</strong> ${Object.values(c.languages ?? {}).join(", ")}</p>
          `;
        })
        .catch(error => {
          resultDiv.textContent = "Error: " + error.message;
        });
    });
  </script>
</body>
</html>
```

**Challenge:** Add a "Random Country" button that fetches a random country. Add a history list of countries you have searched. Make the search work when pressing Enter.

### Key Concepts

| Term | Meaning |
|------|---------|
| `fetch(url)` | Starts a network request |
| **Promise** | A value that arrives in the future |
| `.then()` | Runs code when a Promise succeeds |
| `.catch()` | Runs code when a Promise fails |
| `response.json()` | Parses the response body as JSON |

### What''s Next?
The `.then()` chain works, but there is an even cleaner syntax. Next: **async/await** — the modern way to write asynchronous code!'),

('dev-l19', 'Async/Await: Taming Promises', 'developers', 'Async', 'en', 'intermediate', 35, 150, 19,
'## Async/Await: Taming Promises ⚡

You have learned about Promises and `.then()` chains. They work great, but they can get complicated. **async/await** is a modern JavaScript feature that makes asynchronous code look and behave more like synchronous code — much easier to read and write!

### The Problem with Promise Chains

Nested `.then()` calls can become messy — a problem known as "Promise hell":

```javascript
// Hard to read
fetch("/api/user")
  .then(res => res.json())
  .then(user => {
    return fetch("/api/posts/" + user.id)
      .then(res => res.json())
      .then(posts => {
        return fetch("/api/comments/" + posts[0].id)
          .then(res => res.json())
          .then(comments => {
            console.log(comments);
          });
      });
  });
```

async/await flattens this completely!

### async Functions

Add the `async` keyword before a function to make it asynchronous. An async function always returns a Promise:

```javascript
async function greet() {
  return "Hello!";
}

// Returns a Promise that resolves to "Hello!"
greet().then(message => console.log(message)); // Hello!
```

### await — Wait for a Promise

Inside an async function, use `await` to pause execution until a Promise resolves:

```javascript
async function fetchUser(username) {
  const response = await fetch("https://api.github.com/users/" + username);
  const user = await response.json();
  console.log(user.name);
}

fetchUser("octocat");
```

The `await` keyword makes the code wait on that line until the Promise is done — but it does not block the rest of your programme! Other code keeps running while it waits.

### Rewriting the Nested Chain

```javascript
// Clean, readable async/await version
async function loadData(userId) {
  const userRes = await fetch("/api/user/" + userId);
  const user = await userRes.json();

  const postsRes = await fetch("/api/posts/" + user.id);
  const posts = await postsRes.json();

  const commentsRes = await fetch("/api/comments/" + posts[0].id);
  const comments = await commentsRes.json();

  console.log(comments);
}
```

Much cleaner! Each line reads naturally from top to bottom.

### Error Handling with try/catch

Use try/catch inside async functions to handle errors — just like synchronous code:

```javascript
async function fetchUserData(username) {
  try {
    const response = await fetch("https://api.github.com/users/" + username);

    if (!response.ok) {
      throw new Error("User not found! Status: " + response.status);
    }

    const user = await response.json();
    return user;
  } catch (error) {
    console.log("Error fetching user:", error.message);
    return null;
  }
}

async function displayUser() {
  const user = await fetchUserData("octocat");
  if (user) {
    console.log("Name:", user.name);
    console.log("Repos:", user.public_repos);
  }
}

displayUser();
```

### Promise.all — Run Requests in Parallel

When you have multiple independent async operations, run them simultaneously with `Promise.all`:

```javascript
async function fetchMultipleUsers() {
  // Sequential — slow! Each waits for the previous
  const alice = await fetchUser("alice");
  const bob = await fetchUser("bob");
  const charlie = await fetchUser("charlie");

  // Parallel — fast! All run at the same time
  const [alice, bob, charlie] = await Promise.all([
    fetchUser("alice"),
    fetchUser("bob"),
    fetchUser("charlie")
  ]);
}
```

`Promise.all` fails if ANY request fails. Use `Promise.allSettled` to get results even if some fail:

```javascript
const results = await Promise.allSettled([
  fetch("/api/users"),
  fetch("/api/posts"),
  fetch("/api/broken-endpoint")
]);

results.forEach(result => {
  if (result.status === "fulfilled") {
    console.log("Success:", result.value);
  } else {
    console.log("Failed:", result.reason);
  }
});
```

### Async Patterns in the Real World

#### Loading data when a page opens
```javascript
async function initApp() {
  try {
    const [user, settings, notifications] = await Promise.all([
      fetch("/api/me").then(r => r.json()),
      fetch("/api/settings").then(r => r.json()),
      fetch("/api/notifications").then(r => r.json())
    ]);

    displayUser(user);
    applySettings(settings);
    showNotificationCount(notifications.length);
  } catch (error) {
    showError("Failed to load app data. Please refresh.");
  }
}

document.addEventListener("DOMContentLoaded", initApp);
```

### Activity: Build an Async Weather Dashboard ☀️

```html
<!DOCTYPE html>
<html>
<body>
  <h1>Weather Dashboard ☀️</h1>
  <input type="text" id="cityInput" placeholder="Enter city name...">
  <button id="searchBtn">Get Weather</button>
  <div id="weather"></div>

  <script>
    // Using Open-Meteo (free, no API key needed!)
    async function getCoordinates(city) {
      const url = "https://geocoding-api.open-meteo.com/v1/search?name=" + encodeURIComponent(city) + "&count=1";
      const response = await fetch(url);
      const data = await response.json();
      if (!data.results?.length) throw new Error("City not found: " + city);
      return data.results[0];
    }

    async function getWeather(lat, lon) {
      const url = "https://api.open-meteo.com/v1/forecast?latitude=" + lat + "&longitude=" + lon + "&current_weather=true";
      const response = await fetch(url);
      return response.json();
    }

    async function searchWeather() {
      const city = document.querySelector("#cityInput").value.trim();
      const weatherDiv = document.querySelector("#weather");

      if (!city) return;
      weatherDiv.textContent = "Loading...";

      try {
        const location = await getCoordinates(city);
        const weather = await getWeather(location.latitude, location.longitude);
        const current = weather.current_weather;

        weatherDiv.innerHTML = `
          <h2>${location.name}, ${location.country_code}</h2>
          <p>🌡️ Temperature: ${current.temperature}°C</p>
          <p>💨 Wind speed: ${current.windspeed} km/h</p>
          <p>🧭 Wind direction: ${current.winddirection}°</p>
        `;
      } catch (error) {
        weatherDiv.textContent = "Error: " + error.message;
      }
    }

    document.querySelector("#searchBtn").addEventListener("click", searchWeather);
    document.querySelector("#cityInput").addEventListener("keydown", e => {
      if (e.key === "Enter") searchWeather();
    });
  </script>
</body>
</html>
```

**Challenge:** Add a 7-day forecast. Cache results so the same city is not fetched twice (use an object as a cache). Add a loading spinner while data is fetching.

### async/await vs .then()

| Feature | .then() | async/await |
|---------|---------|-------------|
| Readability | Can get nested and complex | Reads like synchronous code |
| Error handling | .catch() at the end | try/catch blocks |
| Parallel requests | Promise.all | await Promise.all |
| Use when | Simple chains | Complex, sequential operations |

### What''s Next?
Async mastered! Next: **localStorage** — saving data right in the user''s browser!'),

('dev-l20', 'Local Storage: Saving Data in the Browser', 'developers', 'Web APIs', 'en', 'intermediate', 35, 150, 20,
'## Local Storage: Saving Data in the Browser 💾

Have you ever noticed that some websites remember your preferences even after you close and reopen them? Dark mode stays on, your shopping cart is still there, and you are still logged in. How? One answer is **localStorage** — a simple way to save data right in the user''s browser!

### What Is localStorage?

`localStorage` is a built-in browser API that lets you store key-value pairs persistently. The data stays even when the browser is closed — it only disappears when you deliberately clear it.

It is like a tiny private database for your website, stored on the user''s computer.

### Basic localStorage Operations

```javascript
// SAVE data
localStorage.setItem("username", "AlexDev");
localStorage.setItem("theme", "dark");
localStorage.setItem("score", "1500");

// READ data
const username = localStorage.getItem("username"); // "AlexDev"
const theme = localStorage.getItem("theme");       // "dark"
const missing = localStorage.getItem("nothing");   // null (not found)

// DELETE one item
localStorage.removeItem("theme");

// DELETE everything
localStorage.clear();

// Check how many items are stored
console.log(localStorage.length); // Number of items
```

**Important:** localStorage only stores strings. Numbers, booleans, arrays, and objects must be converted!

### Storing Numbers and Booleans

```javascript
// Storing — convert to string
localStorage.setItem("score", String(1500));
localStorage.setItem("isDarkMode", String(true));

// Reading — convert back
const score = parseInt(localStorage.getItem("score")); // 1500 (number)
const isDarkMode = localStorage.getItem("isDarkMode") === "true"; // true (boolean)
```

### Storing Objects with JSON

For objects and arrays, use `JSON.stringify` to save and `JSON.parse` to read:

```javascript
const user = {
  name: "Alex",
  level: 5,
  badges: ["gold", "silver"],
  settings: { theme: "dark", language: "en" }
};

// Save
localStorage.setItem("user", JSON.stringify(user));

// Read
const savedUser = JSON.parse(localStorage.getItem("user"));
console.log(savedUser.name);           // "Alex"
console.log(savedUser.badges);         // ["gold", "silver"]
console.log(savedUser.settings.theme); // "dark"
```

### Safe Reading with Defaults

Always handle the case where the data does not exist yet:

```javascript
function loadSetting(key, defaultValue) {
  const saved = localStorage.getItem(key);
  if (saved === null) return defaultValue;

  try {
    return JSON.parse(saved);
  } catch {
    return saved; // Return raw string if not JSON
  }
}

const theme = loadSetting("theme", "light");
const volume = loadSetting("volume", 80);
const preferences = loadSetting("preferences", { notifications: true });
```

### sessionStorage — The Temporary Twin

`sessionStorage` works exactly like `localStorage` but only lasts for the current tab session. When the tab is closed, the data is gone:

```javascript
// Perfect for temporary state
sessionStorage.setItem("currentStep", "2");
sessionStorage.setItem("formData", JSON.stringify({ name: "Alex" }));

// Reading works the same way
const step = sessionStorage.getItem("currentStep");
```

Use `sessionStorage` for temporary things like wizard steps, unsaved form data, or shopping cart contents before checkout.

### localStorage Limits and Security

**Storage limit:** Usually 5-10 MB per origin. More than enough for settings and small data, but not for images or large files.

**Security:** localStorage is accessible to all JavaScript on your page — including scripts from third-party libraries. Never store:
- Passwords
- Authentication tokens (use secure HTTP-only cookies instead)
- Credit card numbers
- Personal sensitive information

**Per-origin:** Each website has its own localStorage. `google.com` cannot read `facebook.com`''s localStorage.

### Building a Complete Settings System

```javascript
const Settings = {
  defaults: {
    theme: "light",
    fontSize: 16,
    language: "en",
    notifications: true,
    soundEnabled: true
  },

  load() {
    const saved = localStorage.getItem("appSettings");
    if (!saved) return { ...this.defaults };
    try {
      return { ...this.defaults, ...JSON.parse(saved) };
    } catch {
      return { ...this.defaults };
    }
  },

  save(settings) {
    localStorage.setItem("appSettings", JSON.stringify(settings));
  },

  update(key, value) {
    const current = this.load();
    current[key] = value;
    this.save(current);
    return current;
  },

  reset() {
    localStorage.removeItem("appSettings");
  }
};

// Usage
const settings = Settings.load();
console.log(settings.theme); // "light" (default)

Settings.update("theme", "dark");
Settings.update("fontSize", 18);

const updated = Settings.load();
console.log(updated.theme);    // "dark"
console.log(updated.fontSize); // 18
```

### Activity: Build a Notes App with Persistence 📝

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: sans-serif; max-width: 600px; margin: 40px auto; padding: 0 20px; }
    .note { background: #fffde7; border: 1px solid #f9a825; padding: 10px; margin: 5px 0; border-radius: 5px; }
    .note button { float: right; background: #ef5350; color: white; border: none; padding: 3px 8px; cursor: pointer; border-radius: 3px; }
    textarea { width: 100%; height: 80px; padding: 8px; box-sizing: border-box; }
    button.main { padding: 10px 20px; background: #4CAF50; color: white; border: none; cursor: pointer; border-radius: 5px; }
  </style>
</head>
<body>
  <h1>📝 My Notes</h1>
  <textarea id="noteInput" placeholder="Write your note here..."></textarea>
  <button class="main" id="saveBtn">Save Note</button>
  <div id="notesList"></div>

  <script>
    function loadNotes() {
      const saved = localStorage.getItem("notes");
      return saved ? JSON.parse(saved) : [];
    }

    function saveNotes(notes) {
      localStorage.setItem("notes", JSON.stringify(notes));
    }

    function renderNotes() {
      const notes = loadNotes();
      const list = document.querySelector("#notesList");
      list.innerHTML = "";

      if (notes.length === 0) {
        list.innerHTML = "<p>No notes yet. Write your first one!</p>";
        return;
      }

      notes.forEach((note, index) => {
        const div = document.createElement("div");
        div.className = "note";

        const text = document.createElement("span");
        text.textContent = note.text;

        const time = document.createElement("small");
        time.style.display = "block";
        time.style.color = "#888";
        time.textContent = new Date(note.timestamp).toLocaleString();

        const deleteBtn = document.createElement("button");
        deleteBtn.textContent = "Delete";
        deleteBtn.addEventListener("click", () => {
          const notes = loadNotes();
          notes.splice(index, 1);
          saveNotes(notes);
          renderNotes();
        });

        div.appendChild(deleteBtn);
        div.appendChild(text);
        div.appendChild(time);
        list.appendChild(div);
      });
    }

    document.querySelector("#saveBtn").addEventListener("click", () => {
      const input = document.querySelector("#noteInput");
      const text = input.value.trim();
      if (!text) return;

      const notes = loadNotes();
      notes.unshift({ text, timestamp: Date.now() }); // Add to start
      saveNotes(notes);
      renderNotes();
      input.value = "";
    });

    // Load notes when page opens
    renderNotes();
  </script>
</body>
</html>
```

**Challenge:** Add a search bar that filters notes as you type. Add the ability to edit an existing note. Store a "last opened" timestamp so you can show "Welcome back!" if they visited before.

### localStorage vs Other Storage

| Feature | localStorage | sessionStorage | Cookies |
|---------|-------------|---------------|---------|
| Persistence | Until cleared | Until tab closes | Set by server |
| Size | ~5-10 MB | ~5-10 MB | ~4 KB |
| Accessible by | JavaScript | JavaScript | JS + Server |
| Best for | Settings, saved data | Temporary state | Authentication |

### What''s Next?
You have completed Lessons 7-20 of the Developers level! You now have a powerful toolkit: DOM manipulation, events, async data fetching, and client-side storage. The next lessons will take you deeper into advanced JavaScript patterns, frameworks, and professional development techniques. Keep building — you are doing brilliantly!')

ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;
