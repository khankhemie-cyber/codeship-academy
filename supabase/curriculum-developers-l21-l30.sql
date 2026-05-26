-- =============================================================================
-- CODEship Academy — Developers Level Lessons 21–30
-- Ages 11–14 | Intermediate | 35–40 min | 150 xp each
-- =============================================================================

INSERT INTO public.lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES

('dev-l21', 'JavaScript Mini-Project: To-Do List', 'developers', 'Project', 'en', 'intermediate', 40, 150, 21,
'## JavaScript Mini-Project: To-Do List

You have learned variables, functions, arrays, loops, and DOM manipulation. Now it is time to put them all together into a **real project** — a to-do list app that lets you add tasks, mark them done, and delete them.

### What You Are Building

A working to-do list with:
- An input box and button to add new tasks
- A live list that updates as you add items
- A "Done" button that crosses out completed tasks
- A "Delete" button to remove tasks from the list

### Step 1: HTML Structure

Create `index.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My To-Do List</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="app">
    <h1>My To-Do List</h1>

    <div class="input-area">
      <input type="text" id="taskInput" placeholder="What do you need to do?" />
      <button id="addBtn">Add Task</button>
    </div>

    <ul id="taskList"></ul>
  </div>

  <script src="app.js"></script>
</body>
</html>
```

### Step 2: CSS Styling

Create `style.css`:

```css
body {
  font-family: Arial, sans-serif;
  background: #f0f4f8;
  display: flex;
  justify-content: center;
  padding: 40px 20px;
}

.app {
  background: white;
  border-radius: 12px;
  padding: 30px;
  width: 100%;
  max-width: 500px;
  box-shadow: 0 4px 16px rgba(0,0,0,0.1);
}

h1 {
  text-align: center;
  color: #2d3748;
  margin-bottom: 24px;
}

.input-area {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

input {
  flex: 1;
  padding: 10px 14px;
  border: 2px solid #cbd5e0;
  border-radius: 8px;
  font-size: 16px;
}

input:focus {
  outline: none;
  border-color: #4299e1;
}

button {
  padding: 10px 16px;
  background: #4299e1;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 15px;
  font-weight: bold;
}

button:hover {
  background: #3182ce;
}

ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

li {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  margin-bottom: 8px;
  background: #f7fafc;
  border-radius: 8px;
  border: 1px solid #e2e8f0;
}

.task-text {
  flex: 1;
  font-size: 16px;
  color: #2d3748;
}

.task-text.done {
  text-decoration: line-through;
  color: #a0aec0;
}

.btn-done {
  background: #48bb78;
  margin-right: 8px;
}

.btn-done:hover {
  background: #38a169;
}

.btn-delete {
  background: #fc8181;
}

.btn-delete:hover {
  background: #e53e3e;
}
```

### Step 3: JavaScript Logic

Create `app.js`:

```javascript
// Grab elements from the DOM
const taskInput = document.getElementById("taskInput");
const addBtn = document.getElementById("addBtn");
const taskList = document.getElementById("taskList");

// Store tasks in an array
let tasks = [];

// Function: Add a new task
function addTask() {
  const text = taskInput.value.trim();   // .trim() removes extra spaces

  // Do nothing if the input is empty
  if (text === "") {
    alert("Please type something first!");
    return;
  }

  // Create a task object with an id, text, and done status
  const task = {
    id: Date.now(),   // unique number based on current time
    text: text,
    done: false
  };

  tasks.push(task);       // add to the array
  taskInput.value = "";   // clear the input box
  renderTasks();          // update the display
}

// Function: Toggle a task done/not done
function toggleDone(id) {
  // Find the task with the matching id and flip its "done" value
  tasks = tasks.map(function(task) {
    if (task.id === id) {
      return { ...task, done: !task.done };
    }
    return task;
  });
  renderTasks();
}

// Function: Delete a task
function deleteTask(id) {
  // Keep only tasks whose id does NOT match
  tasks = tasks.filter(function(task) {
    return task.id !== id;
  });
  renderTasks();
}

// Function: Render the task list to the DOM
function renderTasks() {
  taskList.innerHTML = "";   // clear the list

  if (tasks.length === 0) {
    taskList.innerHTML = "<li style=''color:#a0aec0;text-align:center;border:none;background:none''>No tasks yet — add one above!</li>";
    return;
  }

  tasks.forEach(function(task) {
    const li = document.createElement("li");

    const span = document.createElement("span");
    span.textContent = task.text;
    span.className = "task-text" + (task.done ? " done" : "");

    const doneBtn = document.createElement("button");
    doneBtn.textContent = task.done ? "Undo" : "Done";
    doneBtn.className = "btn-done";
    doneBtn.onclick = function() { toggleDone(task.id); };

    const deleteBtn = document.createElement("button");
    deleteBtn.textContent = "Delete";
    deleteBtn.className = "btn-delete";
    deleteBtn.onclick = function() { deleteTask(task.id); };

    li.appendChild(span);
    li.appendChild(doneBtn);
    li.appendChild(deleteBtn);
    taskList.appendChild(li);
  });
}

// Event: click the Add button
addBtn.addEventListener("click", addTask);

// Event: press Enter in the input box
taskInput.addEventListener("keydown", function(event) {
  if (event.key === "Enter") {
    addTask();
  }
});
```

### Key Concepts Used

| Concept | Where Used |
|---------|-----------|
| Arrays | `tasks` array stores all task objects |
| Objects | Each task is `{ id, text, done }` |
| `.push()` | Adding a new task |
| `.filter()` | Removing a task |
| `.map()` | Toggling done status |
| DOM creation | `createElement`, `appendChild` |
| Events | `addEventListener` for click and keydown |

### Challenge Extensions

Once your basic app works, try these improvements:

1. **Count display** — Show "3 tasks remaining" above the list
2. **Local Storage** — Save tasks so they survive a page refresh
3. **Priority levels** — Add a dropdown: Low / Medium / High
4. **Due dates** — Add a date input to each task

### Local Storage Bonus Code

```javascript
// Save tasks after every change
function saveTasks() {
  localStorage.setItem("tasks", JSON.stringify(tasks));
}

// Load tasks when the page loads
function loadTasks() {
  const saved = localStorage.getItem("tasks");
  if (saved) {
    tasks = JSON.parse(saved);
    renderTasks();
  }
}

// Call loadTasks() at the bottom of your file
loadTasks();
```

Add `saveTasks()` at the end of `addTask()`, `toggleDone()`, and `deleteTask()` to keep data across refreshes.

### Congratulations!

You just built a real, working web application from scratch using HTML, CSS, and JavaScript. This is exactly how professional developers think: break a problem into small pieces, build each piece, then connect them together.'),

('dev-l22', 'CSS Flexbox Deep Dive', 'developers', 'CSS', 'en', 'intermediate', 35, 150, 22,
'## CSS Flexbox Deep Dive

Flexbox is one of the most powerful layout tools in CSS. It lets you arrange elements in a row or column and control exactly how they are spaced, sized, and aligned — even when screen sizes change.

### The Two Players: Container and Items

Flexbox works with two roles:
- **Flex container** — the parent element with `display: flex`
- **Flex items** — the direct children of that container

```html
<div class="container">   <!-- flex container -->
  <div class="box">A</div>  <!-- flex item -->
  <div class="box">B</div>  <!-- flex item -->
  <div class="box">C</div>  <!-- flex item -->
</div>
```

```css
.container {
  display: flex;   /* This activates flexbox! */
  background: #e2e8f0;
  padding: 10px;
}

.box {
  background: #4299e1;
  color: white;
  padding: 20px;
  margin: 5px;
  font-size: 20px;
}
```

Without flex, the divs stack vertically. With `display: flex`, they line up in a row.

### flex-direction: Which Way?

```css
.container {
  display: flex;
  flex-direction: row;           /* default: left to right */
  /* flex-direction: row-reverse;   right to left */
  /* flex-direction: column;        top to bottom */
  /* flex-direction: column-reverse; bottom to top */
}
```

### justify-content: Main Axis Alignment

`justify-content` controls spacing along the **main axis** (horizontal by default):

```css
.container {
  display: flex;
  justify-content: flex-start;    /* default: pack to the left */
  /* justify-content: flex-end;      pack to the right */
  /* justify-content: center;        center everything */
  /* justify-content: space-between; equal gaps BETWEEN items */
  /* justify-content: space-around;  equal space around items */
  /* justify-content: space-evenly;  truly equal gaps everywhere */
}
```

**space-between** is great for navigation bars. **center** is perfect for hero sections.

### align-items: Cross Axis Alignment

`align-items` controls alignment on the **cross axis** (vertical by default):

```css
.container {
  display: flex;
  height: 200px;
  align-items: stretch;     /* default: items fill the height */
  /* align-items: flex-start;  items stick to the top */
  /* align-items: flex-end;    items stick to the bottom */
  /* align-items: center;      items are centered vertically */
  /* align-items: baseline;    items align to their text baseline */
}
```

**Centering trick** — to center something both horizontally AND vertically:

```css
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;   /* full viewport height */
}
```

### flex-wrap: Handle Overflow

By default, flex items try to fit on one line. If there are too many:

```css
.container {
  display: flex;
  flex-wrap: nowrap;    /* default: squish everything onto one line */
  /* flex-wrap: wrap;      items move to the next line when needed */
  /* flex-wrap: wrap-reverse; same but rows stack from bottom */
}
```

Use `flex-wrap: wrap` for responsive card grids.

### flex-grow: Sharing Space

`flex-grow` tells an item how much extra space it should take:

```css
.sidebar { flex-grow: 1; }   /* gets 1 share of extra space */
.main    { flex-grow: 3; }   /* gets 3 shares — three times as wide */
```

If sidebar gets 1 share and main gets 3 shares, main takes up 75% of the width.

### Practical Example: Navigation Bar

```css
nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  height: 60px;
  background: #2d3748;
  color: white;
}

.nav-logo { font-size: 20px; font-weight: bold; }

.nav-links {
  display: flex;
  gap: 20px;                /* gap adds space between flex items */
  list-style: none;
}
```

### Practical Example: Card Grid

```css
.card-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
}

.card {
  flex: 1 1 250px;   /* grow | shrink | base width */
  background: white;
  border-radius: 8px;
  padding: 16px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}
```

`flex: 1 1 250px` means: "grow to fill space, shrink if needed, but start at 250px wide."

### The flex Shorthand

```css
.item {
  flex: 1;         /* shorthand for flex-grow: 1; flex-shrink: 1; flex-basis: 0% */
  flex: 0 0 200px; /* fixed 200px — do not grow or shrink */
  flex: 2 1 auto;  /* grow twice as fast, shrink normally */
}
```

### Gap — Clean Spacing

Instead of margins on every item, use `gap` on the container:

```css
.container {
  display: flex;
  gap: 16px;          /* same gap between all items */
  /* row-gap: 20px;      gap between rows only */
  /* column-gap: 10px;   gap between columns only */
}
```

### Activity: Build a Page Layout

Create a page with this flex structure:

```html
<header>Logo | Nav links</header>
<main>
  <aside>Sidebar (1 share)</aside>
  <section>Main content (3 shares)</section>
</main>
<footer>Copyright 2024</footer>
```

```css
main {
  display: flex;
  gap: 20px;
  min-height: 400px;
}

aside { flex: 1; background: #edf2f7; }
section { flex: 3; background: #fff; }
```

### Key Takeaways

- `display: flex` turns a container into a flex layout
- `justify-content` aligns items along the main axis (horizontal)
- `align-items` aligns items along the cross axis (vertical)
- `flex-wrap: wrap` lets items move to the next row
- `flex-grow` controls how much space an item takes
- `gap` adds clean spacing between items without margin math'),

('dev-l23', 'CSS Grid: Building Layouts', 'developers', 'CSS', 'en', 'intermediate', 35, 150, 23,
'## CSS Grid: Building Layouts

CSS Grid is a two-dimensional layout system — it works with both rows AND columns at the same time. While Flexbox is great for one direction at a time, Grid excels at full page layouts.

### Activating Grid

```css
.container {
  display: grid;
}
```

That is the start. Now you define columns, rows, and areas.

### grid-template-columns

This is the most important Grid property. It defines how many columns you want and how wide each one is:

```css
.container {
  display: grid;
  grid-template-columns: 200px 200px 200px;   /* 3 fixed columns */
}

/* Better: use fr (fraction) units */
.container {
  grid-template-columns: 1fr 1fr 1fr;   /* 3 equal columns */
}

/* Mix fixed and flexible */
.container {
  grid-template-columns: 200px 1fr;   /* sidebar + flexible main */
}

/* repeat() saves typing */
.container {
  grid-template-columns: repeat(3, 1fr);   /* same as 1fr 1fr 1fr */
}
```

The `fr` unit means "fraction of the remaining space."

### grid-template-rows

Define row heights the same way:

```css
.container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-template-rows: 100px 200px 100px;   /* header, main, footer heights */
}
```

### gap: Spacing Between Cells

```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;              /* same gap for rows and columns */
  /* row-gap: 20px;       row gaps only */
  /* column-gap: 10px;    column gaps only */
}
```

### Placing Items with grid-column and grid-row

By default, items flow left-to-right, row-by-row. You can override this:

```css
.header {
  grid-column: 1 / 3;   /* start at line 1, end at line 3 (spans 2 columns) */
}

.sidebar {
  grid-row: 2 / 4;   /* start at row line 2, end at row line 4 (spans 2 rows) */
}

/* span keyword — easier to read */
.hero {
  grid-column: span 2;   /* spans 2 columns */
  grid-row: span 3;      /* spans 3 rows */
}
```

Grid uses **lines**, not cells. A 3-column grid has 4 vertical lines (1, 2, 3, 4).

### Grid Areas: The Named Layout Approach

The most powerful Grid feature — name regions and draw your layout visually:

```css
.container {
  display: grid;
  grid-template-columns: 200px 1fr;
  grid-template-rows: 60px 1fr 60px;
  grid-template-areas:
    "header  header"
    "sidebar main"
    "footer  footer";
  gap: 10px;
  height: 100vh;
}

header  { grid-area: header; }
.sidebar { grid-area: sidebar; }
main    { grid-area: main; }
footer  { grid-area: footer; }
```

The `"header header"` means the header spans both columns in row 1. This looks exactly like a newspaper or app layout.

### auto-fill and auto-fit: Responsive Without Media Queries

```css
/* Cards that automatically wrap to new rows */
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 16px;
}
```

- `auto-fill` — create as many columns as fit
- `minmax(200px, 1fr)` — each column is at least 200px but can grow
- No media queries needed — the grid adjusts automatically!

### Aligning Items Inside Cells

```css
.container {
  display: grid;
  justify-items: start;    /* horizontal alignment of items within cells */
  /* justify-items: end; */
  /* justify-items: center; */
  /* justify-items: stretch; (default) */

  align-items: start;      /* vertical alignment of items within cells */
  /* align-items: end; */
  /* align-items: center; */
}

/* Override for a single item */
.special {
  justify-self: center;
  align-self: end;
}
```

### Full Page Layout Example

```html
<div class="page">
  <header>CODEship Academy</header>
  <nav>Home | Lessons | Projects</nav>
  <main>Main content here</main>
  <aside>Related links</aside>
  <footer>Copyright 2024</footer>
</div>
```

```css
.page {
  display: grid;
  grid-template-columns: 1fr 250px;
  grid-template-rows: auto auto 1fr auto;
  grid-template-areas:
    "header  header"
    "nav     nav"
    "main    aside"
    "footer  footer";
  gap: 0;
  min-height: 100vh;
}

header { grid-area: header; background: #2d3748; color: white; padding: 16px; }
nav    { grid-area: nav; background: #4a5568; color: white; padding: 12px; }
main   { grid-area: main; padding: 24px; }
aside  { grid-area: aside; background: #edf2f7; padding: 20px; }
footer { grid-area: footer; background: #2d3748; color: white; padding: 16px; text-align: center; }
```

### Grid vs Flexbox: When to Use Which?

| Use Grid when... | Use Flexbox when... |
|-----------------|-------------------|
| Full page layouts | Navigation bars |
| Photo galleries | Button groups |
| Dashboard panels | Card rows |
| Anything 2D (rows AND columns) | Anything 1D (one direction) |

They are not competitors — use both! A Grid layout can contain Flex containers inside it.

### Activity: Build a Magazine Layout

Create a 3-column magazine grid:

```css
.magazine {
  display: grid;
  grid-template-columns: 1fr 2fr 1fr;
  grid-template-rows: auto auto;
  gap: 16px;
}

.featured {
  grid-column: 2 / 3;
  grid-row: 1 / 3;   /* spans both rows in the middle column */
}
```

### Key Takeaways

- `grid-template-columns` defines column widths using `fr` units
- `gap` adds space between cells
- `grid-column: span 2` makes an item span multiple columns
- `grid-template-areas` lets you draw the layout with named regions
- `auto-fill + minmax` creates responsive grids without media queries'),

('dev-l24', 'Responsive Design and Media Queries', 'developers', 'CSS', 'en', 'intermediate', 35, 150, 24,
'## Responsive Design and Media Queries

Responsive design means your website looks great on ALL devices — a tiny phone, a tablet, and a giant desktop monitor. Modern websites must work on every screen size.

### Why Responsive Design Matters

Over 60% of all web traffic comes from mobile devices. If your site only looks good on desktop, you are losing more than half your visitors. Professional developers always design for mobile first.

### The Viewport Meta Tag — Essential Foundation

This one line goes in every HTML `<head>`. Without it, mobile browsers zoom out to show the "desktop" version:

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

- `width=device-width` — use the actual device width, not a fake 980px desktop width
- `initial-scale=1.0` — do not zoom in or out at the start

### Mobile-First Design

The mobile-first approach writes CSS for small screens first, then adds styles for larger screens:

```css
/* Base styles — for mobile phones (small screens) */
.container {
  padding: 16px;
  font-size: 16px;
}

.card-grid {
  display: flex;
  flex-direction: column;   /* Stack cards vertically on mobile */
  gap: 16px;
}

/* Tablet and up — screens 600px and wider */
@media (min-width: 600px) {
  .card-grid {
    flex-direction: row;    /* Side by side on tablet */
    flex-wrap: wrap;
  }

  .card {
    flex: 1 1 calc(50% - 8px);  /* Two columns */
  }
}

/* Desktop — screens 1024px and wider */
@media (min-width: 1024px) {
  .card-grid {
    gap: 24px;
  }

  .card {
    flex: 1 1 calc(33.33% - 16px);  /* Three columns */
  }

  .container {
    max-width: 1200px;
    margin: 0 auto;
  }
}
```

### Media Query Syntax

```css
@media (condition) {
  /* CSS rules that only apply when the condition is true */
}
```

Common conditions:

```css
@media (min-width: 600px)  { /* 600px and wider */ }
@media (max-width: 599px)  { /* 599px and narrower — mobile only */ }
@media (min-width: 600px) and (max-width: 1023px) { /* tablet only */ }
@media (orientation: landscape) { /* sideways phone or wide screen */ }
@media (prefers-color-scheme: dark) { /* user has dark mode on */ }
```

### Common Breakpoints

Industry standard breakpoints (you can use these for every project):

```css
/* Mobile: up to 599px — covered by base styles */

@media (min-width: 600px)  { /* sm — small tablets */ }
@media (min-width: 768px)  { /* md — tablets */ }
@media (min-width: 1024px) { /* lg — laptops */ }
@media (min-width: 1280px) { /* xl — desktops */ }
@media (min-width: 1536px) { /* 2xl — large monitors */ }
```

### Fluid Layouts: Percentages and max-width

Instead of fixed pixel widths, use relative units:

```css
.container {
  width: 90%;          /* 90% of the parent — works on any screen */
  max-width: 1200px;   /* but never wider than 1200px on huge screens */
  margin: 0 auto;      /* centered */
}

img {
  width: 100%;         /* image fills its container */
  max-width: 100%;     /* never wider than its container */
  height: auto;        /* maintain aspect ratio */
}
```

### Fluid Typography

Use `clamp()` to make font sizes scale smoothly:

```css
h1 {
  font-size: clamp(24px, 5vw, 48px);
  /* minimum: 24px | preferred: 5% of viewport width | maximum: 48px */
}

p {
  font-size: clamp(16px, 2vw, 20px);
}
```

The font grows as the screen gets wider but never goes below or above your limits.

### Responsive Navigation

A common pattern — hamburger menu on mobile, full nav on desktop:

```css
/* Mobile: hide the full nav */
.nav-links {
  display: none;
}

/* Mobile: show hamburger menu button */
.hamburger {
  display: block;
}

/* Desktop: show full nav, hide hamburger */
@media (min-width: 768px) {
  .nav-links {
    display: flex;
    gap: 20px;
  }

  .hamburger {
    display: none;
  }
}
```

### Responsive Grid with CSS Grid

The neatest responsive approach — no media queries at all:

```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
}
```

Cards will be at least 280px wide and automatically arrange into as many columns as fit the screen.

### Hiding/Showing Elements

```css
.mobile-only {
  display: block;
}

.desktop-only {
  display: none;
}

@media (min-width: 768px) {
  .mobile-only { display: none; }
  .desktop-only { display: block; }
}
```

### Testing Responsive Designs

You do not need a phone to test! Use browser DevTools:
1. Open DevTools (F12)
2. Click the phone/tablet icon (Toggle Device Toolbar)
3. Choose a device preset or type in any width
4. Resize the window to see how your layout responds

### Activity: Make a Responsive Card Layout

```html
<div class="cards">
  <div class="card"><h2>Card 1</h2><p>Some content here.</p></div>
  <div class="card"><h2>Card 2</h2><p>Some content here.</p></div>
  <div class="card"><h2>Card 3</h2><p>Some content here.</p></div>
  <div class="card"><h2>Card 4</h2><p>Some content here.</p></div>
</div>
```

Challenge: make 1 column on mobile, 2 on tablet, 4 on desktop using only CSS.

### Key Takeaways

- The viewport meta tag is required for every responsive page
- Mobile-first means write small-screen styles first, then use `min-width` queries
- `max-width: 1200px; margin: 0 auto` centers content on large screens
- `clamp()` creates smooth fluid typography
- CSS Grid with `auto-fit` and `minmax()` is the easiest responsive layout method'),

('dev-l25', 'CSS Animations and Transitions', 'developers', 'CSS', 'en', 'intermediate', 35, 150, 25,
'## CSS Animations and Transitions

CSS lets you animate elements without writing any JavaScript. Transitions handle simple state changes (like hover effects) while `@keyframes` animations run on their own timetable with multiple steps.

### Transitions: Smooth State Changes

A transition smoothly animates a property when it changes value:

```css
.button {
  background: #4299e1;
  color: white;
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;

  /* The transition */
  transition: background 0.3s ease;
  /*          property  duration  timing-function */
}

.button:hover {
  background: #2b6cb0;   /* This change will be animated smoothly */
}
```

Without the transition, the color snaps instantly. With it, it fades over 0.3 seconds.

### Transition Properties

```css
.card {
  transition-property: transform;       /* which property animates */
  transition-duration: 0.4s;            /* how long */
  transition-delay: 0s;                 /* wait before starting */
  transition-timing-function: ease-out; /* acceleration curve */
}

/* Shorthand — most common form */
.card {
  transition: transform 0.4s ease-out;
}

/* Animate multiple properties */
.card {
  transition: transform 0.4s ease, box-shadow 0.3s ease, background 0.2s ease;
}

/* Animate ALL changing properties */
.card {
  transition: all 0.3s ease;
}
```

### Timing Functions

```css
.a { transition-timing-function: ease;        } /* slow-fast-slow (default) */
.b { transition-timing-function: ease-in;     } /* slow start */
.c { transition-timing-function: ease-out;    } /* slow end — feels natural */
.d { transition-timing-function: ease-in-out; } /* slow start AND end */
.e { transition-timing-function: linear;      } /* constant speed */
.f { transition-timing-function: cubic-bezier(0.68, -0.55, 0.27, 1.55); } /* bounce! */
```

`ease-out` is the most natural-feeling timing for most UI interactions.

### Common Transition Examples

```css
/* Lift a card on hover */
.card {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.card:hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 24px rgba(0,0,0,0.15);
}

/* Grow a button on hover */
.btn {
  transition: transform 0.15s ease-out;
}
.btn:hover {
  transform: scale(1.05);
}

/* Fade in a tooltip */
.tooltip {
  opacity: 0;
  transition: opacity 0.3s ease;
}
.parent:hover .tooltip {
  opacity: 1;
}
```

### @keyframes: Full Animations

For animations that run automatically (not just on hover), use `@keyframes`:

```css
/* 1. Define the animation */
@keyframes slideIn {
  from {
    transform: translateX(-100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

/* 2. Apply the animation to an element */
.hero-text {
  animation: slideIn 0.6s ease-out forwards;
  /*         name    duration  timing  fill-mode */
}
```

Multi-step animations use percentages:

```css
@keyframes bounce {
  0%   { transform: translateY(0); }
  30%  { transform: translateY(-30px); }
  60%  { transform: translateY(-10px); }
  80%  { transform: translateY(-20px); }
  100% { transform: translateY(0); }
}

.ball {
  animation: bounce 1s ease-in-out infinite;
}
```

### Animation Properties

```css
.element {
  animation-name: slideIn;             /* which @keyframes to use */
  animation-duration: 0.6s;           /* how long one cycle lasts */
  animation-delay: 0.2s;              /* wait before starting */
  animation-timing-function: ease;    /* acceleration curve */
  animation-iteration-count: 1;       /* how many times (or infinite) */
  animation-direction: normal;        /* normal / reverse / alternate */
  animation-fill-mode: forwards;      /* keep the end state after finishing */
  animation-play-state: running;      /* running / paused */
}

/* Shorthand */
.element {
  animation: slideIn 0.6s ease 0.2s 1 normal forwards;
}
```

### Useful Animation Examples

```css
/* Fade in on load */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* Spinning loader */
@keyframes spin {
  from { transform: rotate(0deg); }
  to   { transform: rotate(360deg); }
}

.loader {
  width: 40px;
  height: 40px;
  border: 4px solid #e2e8f0;
  border-top-color: #4299e1;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

/* Pulsing notification dot */
@keyframes pulse {
  0%, 100% { transform: scale(1); opacity: 1; }
  50%       { transform: scale(1.4); opacity: 0.7; }
}

.notification-dot {
  animation: pulse 1.5s ease-in-out infinite;
}

/* Typing cursor blink */
@keyframes blink {
  0%, 100% { opacity: 1; }
  50%       { opacity: 0; }
}

.cursor::after {
  content: "|";
  animation: blink 1s step-end infinite;
}
```

### Animate on Scroll with a CSS Class

JavaScript adds the class when the element enters the viewport, CSS does the animating:

```css
.card {
  opacity: 0;
  transform: translateY(40px);
  transition: opacity 0.5s ease, transform 0.5s ease;
}

.card.visible {
  opacity: 1;
  transform: translateY(0);
}
```

### Performance Tips

Animate only **transform** and **opacity** for silky-smooth animations. These properties are handled by the GPU and never cause layout recalculations:

```css
/* GOOD — GPU-accelerated, smooth */
.fast { transition: transform 0.3s ease; }
.fast { transition: opacity 0.3s ease; }

/* SLOW — triggers layout recalculation */
.slow { transition: width 0.3s ease; }      /* avoid for animations */
.slow { transition: margin 0.3s ease; }     /* avoid for animations */
.slow { transition: height 0.3s ease; }     /* avoid for animations */
```

### Activity: Animate Your To-Do List

Add animations to the to-do list from Lesson 21:

```css
li {
  animation: fadeIn 0.3s ease forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateX(-20px); }
  to   { opacity: 1; transform: translateX(0); }
}

.task-text.done {
  transition: color 0.3s ease, text-decoration 0.3s ease;
}

button {
  transition: transform 0.1s ease, background 0.2s ease;
}

button:hover {
  transform: scale(1.05);
}

button:active {
  transform: scale(0.95);
}
```

### Key Takeaways

- `transition` smoothly animates a CSS property when it changes (e.g., on hover)
- `@keyframes` defines multi-step animations that run automatically
- `animation-iteration-count: infinite` loops an animation forever
- `animation-fill-mode: forwards` keeps the final state after the animation ends
- Only animate `transform` and `opacity` for best performance'),

('dev-l26', 'Introduction to APIs', 'developers', 'APIs', 'en', 'intermediate', 35, 150, 26,
'## Introduction to APIs

An API is one of the most important concepts in modern web development. Once you understand APIs, you can connect your website to live data from anywhere in the world — weather, sports scores, maps, music, and more.

### What is an API?

**API** stands for **Application Programming Interface**. It is a way for two pieces of software to talk to each other.

Think of it like a restaurant:
- You are the customer (your code / browser)
- The menu is the API documentation — it lists what you can order
- The kitchen is the server (another company''s computer)
- Your order is the **request**
- The food that arrives is the **response**

You do not need to know how the kitchen works. You just follow the menu (API docs), place an order (make a request), and receive the food (data).

### REST APIs

Most web APIs are **REST APIs** (Representational State Transfer). REST APIs:
- Live at a URL (called an **endpoint**)
- Send and receive data in **JSON** format
- Use HTTP methods like GET, POST, PUT, DELETE

The most common method is **GET** — asking for data.

### Anatomy of an API Request

A typical API URL looks like this:

```
https://api.openweathermap.org/data/2.5/weather?q=London&appid=YOUR_KEY
```

Breaking it down:
- `https://api.openweathermap.org` — the domain (the server)
- `/data/2.5/weather` — the endpoint (which data to get)
- `?q=London` — a query parameter (what city)
- `&appid=YOUR_KEY` — an API key (your password to use the service)

### API Keys

Many APIs require an API key — a unique secret code that identifies your app. Keep these secret! Never put them in public code.

Some APIs are free with no key required:
- `https://api.agify.io/?name=michael` — predicts age from a name
- `https://dog.ceo/api/breeds/image/random` — random dog photo
- `https://api.quotable.io/random` — random inspirational quote
- `https://catfact.ninja/fact` — random cat fact

### What is JSON?

**JSON** (JavaScript Object Notation) is the language APIs use to send data. It looks exactly like a JavaScript object:

```json
{
  "name": "London",
  "temperature": 18.5,
  "conditions": "Cloudy",
  "wind_speed": 12,
  "forecast": ["rainy", "sunny", "cloudy"]
}
```

JSON rules:
- Keys must be in double quotes `""`
- Strings must use double quotes
- Can contain: strings, numbers, booleans, null, arrays, objects

### The fetch() Function

JavaScript has a built-in `fetch()` function to get data from APIs:

```javascript
fetch("https://api.agify.io/?name=michael")
  .then(function(response) {
    return response.json();   // convert the raw response to a JS object
  })
  .then(function(data) {
    console.log(data);         // { name: "michael", age: 30, count: 200000 }
    console.log(data.name);    // "michael"
    console.log(data.age);     // 30
  })
  .catch(function(error) {
    console.log("Something went wrong:", error);
  });
```

The `.then()` chain works because `fetch()` is **asynchronous** — it does not freeze the browser while waiting for the server to respond. The code inside `.then()` runs AFTER the data arrives.

### A Complete API Example

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Dog Photo Generator</title>
</head>
<body>
  <h1>Random Dog Photo</h1>
  <button id="fetchBtn">Get a Dog!</button>
  <br><br>
  <img id="dogImage" src="" alt="Random dog" width="400" style="display:none; border-radius:12px">
  <p id="message"></p>

  <script>
    const btn = document.getElementById("fetchBtn");
    const img = document.getElementById("dogImage");
    const msg = document.getElementById("message");

    btn.addEventListener("click", function() {
      msg.textContent = "Fetching a dog...";

      fetch("https://dog.ceo/api/breeds/image/random")
        .then(function(response) {
          return response.json();
        })
        .then(function(data) {
          img.src = data.message;   // the API returns { message: "https://...", status: "success" }
          img.style.display = "block";
          msg.textContent = "";
        })
        .catch(function(error) {
          msg.textContent = "Could not fetch dog. Check your connection.";
          console.log(error);
        });
    });
  </script>
</body>
</html>
```

### Response Status Codes

APIs use HTTP status codes to tell you if a request succeeded:

| Code | Meaning |
|------|---------|
| 200 | OK — success! |
| 201 | Created — something was created |
| 400 | Bad Request — you sent bad data |
| 401 | Unauthorized — missing or bad API key |
| 403 | Forbidden — you do not have permission |
| 404 | Not Found — endpoint does not exist |
| 429 | Too Many Requests — you hit the rate limit |
| 500 | Server Error — the API is broken |

```javascript
fetch("https://api.example.com/data")
  .then(function(response) {
    if (!response.ok) {
      throw new Error("Request failed with status: " + response.status);
    }
    return response.json();
  })
  .then(function(data) {
    console.log(data);
  })
  .catch(function(error) {
    console.log("Error:", error.message);
  });
```

### API Documentation

Every good API has documentation. It tells you:
- The base URL
- Available endpoints
- Required and optional parameters
- What the response looks like
- Rate limits and authentication

Always read the docs before using a new API!

### Activity: Fetch a Quote

Build a quote displayer using the free Quotable API:

```javascript
fetch("https://api.quotable.io/random")
  .then(r => r.json())
  .then(function(data) {
    document.getElementById("quote").textContent = `"${data.content}"`;
    document.getElementById("author").textContent = `— ${data.author}`;
  });
```

### Key Takeaways

- An API lets your code talk to another server and get data
- REST APIs use URLs as endpoints and return JSON data
- `fetch()` is JavaScript''s built-in way to make API requests
- `.then()` handles the response after it arrives (asynchronous)
- `.catch()` handles errors when something goes wrong
- Always check HTTP status codes to know if a request succeeded'),

('dev-l27', 'Working with JSON Data', 'developers', 'APIs', 'en', 'intermediate', 35, 150, 27,
'## Working with JSON Data

You learned what JSON is in the last lesson. Now you will master reading it, navigating deep inside it, converting it to and from strings, and displaying it beautifully on a web page.

### JSON is Already JavaScript

When `fetch()` calls `.json()`, it converts the raw text into a real JavaScript object. From that point you work with it exactly like any JS object or array:

```json
{
  "user": {
    "name": "Jordan",
    "age": 13,
    "hobbies": ["coding", "gaming", "reading"],
    "address": {
      "city": "Austin",
      "country": "USA"
    }
  }
}
```

After `.json()`:

```javascript
data.user.name               // "Jordan"
data.user.age                // 13
data.user.hobbies[0]         // "coding"
data.user.hobbies.length     // 3
data.user.address.city       // "Austin"
```

### Nested Objects — Going Deeper

APIs often return deeply nested data. Navigate with dot notation or bracket notation:

```javascript
const weather = {
  "city": "New York",
  "current": {
    "temp": 22,
    "feels_like": 20,
    "humidity": 65,
    "conditions": [
      { "main": "Clouds", "description": "overcast clouds" }
    ]
  },
  "forecast": [
    { "day": "Mon", "high": 24, "low": 18 },
    { "day": "Tue", "high": 21, "low": 15 },
    { "day": "Wed", "high": 19, "low": 12 }
  ]
};

// Accessing nested values
console.log(weather.city);                                    // "New York"
console.log(weather.current.temp);                            // 22
console.log(weather.current.conditions[0].description);       // "overcast clouds"
console.log(weather.forecast[0].day);                         // "Mon"
console.log(weather.forecast[1].high);                        // 21
```

### Looping Over API Arrays

Most useful APIs return arrays of items. Use `.forEach()`, `.map()`, or `for...of`:

```javascript
const people = [
  { "name": "Alice", "age": 12, "grade": 7 },
  { "name": "Bob", "age": 13, "grade": 8 },
  { "name": "Carlos", "age": 11, "grade": 6 }
];

// forEach — do something for each item
people.forEach(function(person) {
  console.log(person.name + " is in grade " + person.grade);
});

// map — transform each item into something new
const names = people.map(function(person) {
  return person.name;
});
console.log(names);   // ["Alice", "Bob", "Carlos"]

// filter — keep only some items
const olderKids = people.filter(function(person) {
  return person.age >= 12;
});
console.log(olderKids);   // Alice and Bob
```

### Displaying JSON in the DOM

The real skill is turning API data into HTML elements:

```javascript
fetch("https://jsonplaceholder.typicode.com/users")
  .then(r => r.json())
  .then(function(users) {
    const list = document.getElementById("user-list");

    users.forEach(function(user) {
      const card = document.createElement("div");
      card.className = "user-card";
      card.innerHTML = `
        <h2>${user.name}</h2>
        <p>Email: ${user.email}</p>
        <p>City: ${user.address.city}</p>
        <p>Company: ${user.company.name}</p>
      `;
      list.appendChild(card);
    });
  });
```

Note: `jsonplaceholder.typicode.com` is a free practice API with fake users, posts, and comments.

### JSON.parse() and JSON.stringify()

Sometimes JSON arrives as a plain text string (from localStorage, files, etc.) and you need to convert it:

```javascript
// JSON.parse() — convert a JSON string into a JavaScript object
const jsonString = ''{"name":"Alice","age":12}'';
const obj = JSON.parse(jsonString);
console.log(obj.name);    // "Alice"
console.log(obj.age);     // 12

// JSON.stringify() — convert a JavaScript object into a JSON string
const user = { name: "Bob", score: 450, level: "builders" };
const str = JSON.stringify(user);
console.log(str);   // ''{"name":"Bob","score":450,"level":"builders"}''

// Pretty-print with 2-space indentation
const pretty = JSON.stringify(user, null, 2);
console.log(pretty);
/* Output:
{
  "name": "Bob",
  "score": 450,
  "level": "builders"
}
*/
```

### Real-World Pattern: Loading and Displaying Posts

```html
<div id="posts"></div>

<script>
fetch("https://jsonplaceholder.typicode.com/posts?_limit=5")
  .then(r => r.json())
  .then(function(posts) {
    const container = document.getElementById("posts");

    posts.forEach(function(post) {
      const article = document.createElement("article");
      article.innerHTML = `
        <h3>${post.title}</h3>
        <p>${post.body}</p>
        <small>Post #${post.id} by User ${post.userId}</small>
        <hr>
      `;
      container.appendChild(article);
    });
  })
  .catch(function(error) {
    document.getElementById("posts").textContent = "Failed to load posts.";
    console.error(error);
  });
</script>
```

### Checking for Missing Data

APIs do not always send every field. Use optional chaining `?.` and defaults to handle missing values:

```javascript
// Without safety check — can crash if user.address is undefined
console.log(user.address.city);         // ERROR if address is missing

// With optional chaining — safely returns undefined instead of crashing
console.log(user?.address?.city);       // undefined (no crash)

// Provide a fallback with || (or)
const city = user?.address?.city || "Unknown city";
console.log(city);   // "Unknown city" if missing
```

### Async/Await — Cleaner Code

The modern way to write fetch code — reads like regular top-to-bottom code:

```javascript
async function loadUsers() {
  try {
    const response = await fetch("https://jsonplaceholder.typicode.com/users");
    const users = await response.json();

    users.forEach(function(user) {
      console.log(user.name + " — " + user.email);
    });

  } catch (error) {
    console.log("Error loading users:", error);
  }
}

loadUsers();
```

`async` before a function means it can use `await`. `await` pauses the function until the promise resolves — without blocking the browser.

### Activity: Display a Product Catalog

Use the fake store API to build a product grid:

```javascript
async function loadProducts() {
  const response = await fetch("https://fakestoreapi.com/products?limit=8");
  const products = await response.json();
  const grid = document.getElementById("product-grid");

  products.forEach(function(product) {
    const card = document.createElement("div");
    card.className = "product-card";
    card.innerHTML = `
      <img src="${product.image}" alt="${product.title}" height="200">
      <h3>${product.title.slice(0, 40)}...</h3>
      <p class="price">$${product.price}</p>
      <p class="category">${product.category}</p>
    `;
    grid.appendChild(card);
  });
}

loadProducts();
```

### Key Takeaways

- Navigate JSON with dot notation: `data.user.address.city`
- Loop over JSON arrays with `.forEach()`, `.map()`, `.filter()`
- `JSON.parse()` converts a string to an object; `JSON.stringify()` goes the other way
- Use optional chaining `?.` to safely handle missing fields
- `async/await` makes asynchronous fetch code easier to read and write'),

('dev-l28', 'Building a Weather App', 'developers', 'Project', 'en', 'intermediate', 40, 150, 28,
'## Building a Weather App

This is your second major project. You will build a fully functional weather app that fetches real (or mock) data and displays it with a clean, responsive design. This lesson combines HTML, CSS, JavaScript, DOM manipulation, and API skills.

### Project Overview

Your weather app will:
- Let the user type a city name
- Show current temperature, conditions, humidity, and wind speed
- Display a 3-day forecast
- Show appropriate weather icons
- Handle errors gracefully

### Step 1: Project Structure

Create three files:
- `index.html` — the page structure
- `style.css` — the visual design
- `app.js` — the JavaScript logic

### Step 2: HTML

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Weather App</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="app">
    <h1>Weather App</h1>

    <div class="search-bar">
      <input type="text" id="cityInput" placeholder="Enter a city..." />
      <button id="searchBtn">Search</button>
    </div>

    <div id="errorMsg" class="error hidden"></div>
    <div id="loadingMsg" class="loading hidden">Fetching weather data...</div>

    <div id="weatherDisplay" class="hidden">
      <div class="current-weather">
        <div class="city-name" id="cityName"></div>
        <div class="weather-icon" id="weatherIcon"></div>
        <div class="temperature" id="temperature"></div>
        <div class="conditions" id="conditions"></div>
        <div class="details">
          <div class="detail"><span>Humidity</span><span id="humidity"></span></div>
          <div class="detail"><span>Wind Speed</span><span id="windSpeed"></span></div>
          <div class="detail"><span>Feels Like</span><span id="feelsLike"></span></div>
        </div>
      </div>

      <div class="forecast" id="forecast"></div>
    </div>
  </div>

  <script src="app.js"></script>
</body>
</html>
```

### Step 3: CSS

```css
* { box-sizing: border-box; margin: 0; padding: 0; }

body {
  font-family: "Segoe UI", Arial, sans-serif;
  background: linear-gradient(135deg, #667eea, #764ba2);
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding: 40px 20px;
}

.app {
  background: rgba(255,255,255,0.15);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  padding: 32px;
  width: 100%;
  max-width: 480px;
  color: white;
}

h1 { text-align: center; font-size: 28px; margin-bottom: 24px; }

.search-bar {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
}

input {
  flex: 1;
  padding: 12px 16px;
  border: none;
  border-radius: 10px;
  font-size: 16px;
  background: rgba(255,255,255,0.3);
  color: white;
}
input::placeholder { color: rgba(255,255,255,0.7); }
input:focus { outline: 2px solid rgba(255,255,255,0.6); }

button {
  padding: 12px 20px;
  background: rgba(255,255,255,0.3);
  border: none;
  border-radius: 10px;
  color: white;
  font-size: 15px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.2s;
}
button:hover { background: rgba(255,255,255,0.45); }

.hidden { display: none !important; }
.error { background: rgba(220,53,69,0.4); padding: 12px; border-radius: 10px; text-align: center; }
.loading { text-align: center; font-style: italic; opacity: 0.8; }

.current-weather { text-align: center; margin: 20px 0; }
.city-name { font-size: 26px; font-weight: bold; margin-bottom: 8px; }
.weather-icon { font-size: 60px; margin: 10px 0; }
.temperature { font-size: 52px; font-weight: 300; }
.conditions { font-size: 18px; opacity: 0.9; margin-bottom: 16px; text-transform: capitalize; }

.details {
  display: flex;
  justify-content: space-around;
  background: rgba(255,255,255,0.15);
  border-radius: 12px;
  padding: 12px;
  margin-top: 12px;
}
.detail { display: flex; flex-direction: column; align-items: center; gap: 4px; }
.detail span:first-child { font-size: 12px; opacity: 0.7; text-transform: uppercase; }
.detail span:last-child { font-size: 18px; font-weight: bold; }

.forecast {
  display: flex;
  justify-content: space-between;
  gap: 8px;
  margin-top: 20px;
}
.forecast-day {
  flex: 1;
  background: rgba(255,255,255,0.15);
  border-radius: 12px;
  padding: 12px;
  text-align: center;
}
.forecast-day .day { font-size: 13px; opacity: 0.7; }
.forecast-day .icon { font-size: 28px; margin: 6px 0; }
.forecast-day .temp { font-size: 16px; font-weight: bold; }
```

### Step 4: JavaScript with Mock Data

Since the OpenWeather API requires a free key, we use a realistic mock function for learning. The logic is identical — just swap the mock for a real fetch call when you have a key.

```javascript
// Mock weather data (in a real app, this comes from the API)
const mockWeatherDB = {
  "london":   { temp: 14, feelsLike: 11, conditions: "cloudy", humidity: 78, wind: 18, icon: "☁️",
                forecast: [{day:"Mon",temp:14,icon:"🌦️"},{day:"Tue",temp:16,icon:"⛅"},{day:"Wed",temp:12,icon:"🌧️"}] },
  "new york": { temp: 22, feelsLike: 20, conditions: "sunny", humidity: 55, wind: 10, icon: "☀️",
                forecast: [{day:"Mon",temp:22,icon:"☀️"},{day:"Tue",temp:20,icon:"⛅"},{day:"Wed",temp:18,icon:"🌦️"}] },
  "tokyo":    { temp: 26, feelsLike: 28, conditions: "humid and warm", humidity: 85, wind: 8, icon: "🌤️",
                forecast: [{day:"Mon",temp:26,icon:"🌤️"},{day:"Tue",temp:24,icon:"⛅"},{day:"Wed",temp:27,icon:"☀️"}] },
  "sydney":   { temp: 19, feelsLike: 18, conditions: "partly cloudy", humidity: 62, wind: 22, icon: "⛅",
                forecast: [{day:"Mon",temp:19,icon:"⛅"},{day:"Tue",temp:21,icon:"☀️"},{day:"Wed",temp:18,icon:"🌦️"}] },
  "paris":    { temp: 16, feelsLike: 14, conditions: "light rain", humidity: 80, wind: 14, icon: "🌧️",
                forecast: [{day:"Mon",temp:16,icon:"🌧️"},{day:"Tue",temp:18,icon:"🌦️"},{day:"Wed",temp:20,icon:"⛅"}] }
};

// Grab DOM elements
const cityInput = document.getElementById("cityInput");
const searchBtn = document.getElementById("searchBtn");
const errorMsg = document.getElementById("errorMsg");
const loadingMsg = document.getElementById("loadingMsg");
const weatherDisplay = document.getElementById("weatherDisplay");

// Helper — show/hide elements
function showElement(el) { el.classList.remove("hidden"); }
function hideElement(el) { el.classList.add("hidden"); }

// Main function — get weather for a city
function getWeather() {
  const city = cityInput.value.trim();

  if (!city) {
    showError("Please enter a city name.");
    return;
  }

  // Show loading, hide others
  hideElement(errorMsg);
  hideElement(weatherDisplay);
  showElement(loadingMsg);

  // Simulate a network delay (500ms)
  setTimeout(function() {
    hideElement(loadingMsg);

    const data = mockWeatherDB[city.toLowerCase()];

    if (!data) {
      showError(`City "${city}" not found. Try: London, New York, Tokyo, Sydney, or Paris.`);
      return;
    }

    displayWeather(city, data);
  }, 500);
}

// Display the weather data
function displayWeather(city, data) {
  document.getElementById("cityName").textContent = city.charAt(0).toUpperCase() + city.slice(1);
  document.getElementById("weatherIcon").textContent = data.icon;
  document.getElementById("temperature").textContent = data.temp + "°C";
  document.getElementById("conditions").textContent = data.conditions;
  document.getElementById("humidity").textContent = data.humidity + "%";
  document.getElementById("windSpeed").textContent = data.wind + " km/h";
  document.getElementById("feelsLike").textContent = data.feelsLike + "°C";

  // Build forecast
  const forecastEl = document.getElementById("forecast");
  forecastEl.innerHTML = "";
  data.forecast.forEach(function(day) {
    const div = document.createElement("div");
    div.className = "forecast-day";
    div.innerHTML = `
      <div class="day">${day.day}</div>
      <div class="icon">${day.icon}</div>
      <div class="temp">${day.temp}°C</div>
    `;
    forecastEl.appendChild(div);
  });

  showElement(weatherDisplay);
}

function showError(message) {
  errorMsg.textContent = message;
  showElement(errorMsg);
}

// Events
searchBtn.addEventListener("click", getWeather);
cityInput.addEventListener("keydown", function(e) {
  if (e.key === "Enter") getWeather();
});
```

### Connecting to the Real OpenWeather API

When you get a free API key from openweathermap.org, replace the mock function with:

```javascript
async function getWeather() {
  const city = cityInput.value.trim();
  const API_KEY = "YOUR_KEY_HERE";   // store this safely!
  const url = `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${API_KEY}&units=metric`;

  const response = await fetch(url);
  const data = await response.json();

  document.getElementById("temperature").textContent = Math.round(data.main.temp) + "°C";
  document.getElementById("conditions").textContent = data.weather[0].description;
  document.getElementById("humidity").textContent = data.main.humidity + "%";
  // ...etc
}
```

### Project Challenges

Once the basic app works:
1. Add a "Use My Location" button with the Geolocation API
2. Toggle between Celsius and Fahrenheit
3. Store the last searched city in localStorage
4. Add weather backgrounds that change based on conditions (sunny = yellow gradient, rainy = grey, etc.)

### Key Takeaways

- Real apps combine HTML structure, CSS design, and JavaScript logic
- Mock data lets you build and test the full UI before you have an API key
- `setTimeout()` simulates network delays during development
- Use helper functions like `showElement` and `hideElement` to keep DOM code clean
- The transition from mock data to a real API is usually just swapping one function'),

('dev-l29', 'Version Control with Git', 'developers', 'Tools', 'en', 'intermediate', 35, 150, 29,
'## Version Control with Git

Git is the most important developer tool you will ever learn. It tracks every change you make to your code, lets you experiment without fear, and lets teams of hundreds of developers work on the same project without overwriting each other''s work.

### What is Version Control?

Imagine writing a 10-page essay. Every day you save a new copy: `essay.docx`, `essay_v2.docx`, `essay_final.docx`, `essay_FINAL_REAL.docx`. Sound familiar?

Git solves this properly. It remembers every change you make, who made it, and when — without you duplicating files. You can go back to any previous version instantly.

### What is Git?

**Git** is version control software that runs on your computer. **GitHub** is a website that stores your Git repositories online so you can share them and back them up.

Think of Git as your personal time machine for code. Think of GitHub as Google Drive — but for code, with superpowers.

### Installing Git

Check if you have it:
```
git --version
```

If not, download from git-scm.com (free for all operating systems).

Configure your identity (do this once):
```
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

### The Core Git Workflow

Every Git project follows this cycle:

```
Write code → Stage changes → Commit → Push to GitHub
```

Let''s learn each step.

### git init — Create a Repository

A **repository** (repo) is a folder that Git is tracking.

```bash
# Create a new project folder and enter it
mkdir my-weather-app
cd my-weather-app

# Tell Git to start tracking this folder
git init
```

You will see: `Initialized empty Git repository in ...`

Git creates a hidden `.git` folder inside. That folder is Git''s database.

### git status — What Changed?

Your most-used command:

```bash
git status
```

This shows:
- Which files are new (untracked)
- Which files have been modified
- Which files are staged (ready to commit)

### git add — Stage Your Changes

Staging means choosing WHICH changes to include in the next commit:

```bash
git add index.html          # stage one file
git add style.css app.js    # stage multiple files
git add .                   # stage ALL changed files in current directory
```

Think of staging as packing a box. You choose what goes in before you seal it.

### git commit — Save a Snapshot

A **commit** is a permanent snapshot of your staged changes:

```bash
git commit -m "Add search bar and weather display"
```

The `-m` flag is followed by your **commit message** — a short description of what you changed and why.

Good commit messages:
```
git commit -m "Add city search functionality"
git commit -m "Fix temperature display bug"
git commit -m "Update CSS for mobile responsiveness"
```

Bad commit messages:
```
git commit -m "stuff"
git commit -m "asdfgh"
git commit -m "changes"
```

### git log — See Your History

```bash
git log
```

Shows every commit with its ID (hash), author, date, and message:

```
commit a3f8c9d (HEAD -> main)
Author: Jordan Smith <jordan@example.com>
Date:   Mon May 26 10:30:00 2024
    Add 3-day forecast feature

commit 1b2d4f6
Author: Jordan Smith <jordan@example.com>
Date:   Mon May 26 09:15:00 2024
    Create initial project structure
```

```bash
git log --oneline    # compact one-line view
```

### Branches: Parallel Universes

A **branch** is a separate line of development. The default branch is called `main`.

```bash
git branch                    # list all branches
git branch add-dark-mode      # create a new branch
git checkout add-dark-mode    # switch to that branch
# or combine both into one command:
git checkout -b add-dark-mode
```

Now any commits you make go on the `add-dark-mode` branch. The `main` branch stays untouched.

When your feature is done, merge it back:

```bash
git checkout main             # go back to main
git merge add-dark-mode       # bring in the changes
```

### Connecting to GitHub

1. Create a free account at github.com
2. Create a new repository (click the + button → New repository)
3. Copy the URL (looks like `https://github.com/yourname/my-weather-app.git`)

```bash
# Tell your local repo where GitHub is
git remote add origin https://github.com/yourname/my-weather-app.git

# Push your code to GitHub
git push -u origin main
```

`-u origin main` sets the default so future pushes are just `git push`.

### Getting Code from GitHub

```bash
# Copy a repo to your computer
git clone https://github.com/someone/project.git

# Get the latest changes from GitHub (if others updated it)
git pull
```

### The Complete Daily Workflow

```bash
# Start of day — get the latest code
git pull

# Work on your feature...

# See what changed
git status

# Stage your changes
git add .

# Commit with a good message
git commit -m "Fix login button alignment on mobile"

# Push to GitHub
git push
```

### Undoing Mistakes

```bash
# Unstage a file (undo git add)
git restore --staged style.css

# Discard changes to a file (WARNING: this cannot be undone)
git restore style.css

# Go back to a previous commit (creates a safe new commit)
git revert HEAD

# See the difference between your current code and last commit
git diff
```

### The .gitignore File

Some files should never be committed: passwords, API keys, `node_modules` folders, etc. List them in `.gitignore`:

```
# .gitignore
node_modules/
.env
.DS_Store
*.log
secret-keys.txt
```

Git will ignore any file matching these patterns.

### Activity: Version Your Weather App

1. `git init` in your weather app folder
2. Create a `.gitignore` with `*.log` and `.DS_Store`
3. `git add .` and `git commit -m "Create weather app v1"`
4. Create a branch: `git checkout -b add-forecast`
5. Add the forecast feature
6. Commit: `git commit -m "Add 3-day forecast"`
7. Merge back to main: `git checkout main && git merge add-forecast`

### Key Takeaways

- Git tracks every change to your code — you can always go back
- `git add` stages changes; `git commit` saves them permanently
- Write clear, descriptive commit messages
- Branches let you experiment safely without breaking working code
- GitHub stores your repos online for backup and collaboration
- `.gitignore` prevents sensitive files from being committed'),

('dev-l30', 'Developers: JavaScript Milestone Review', 'developers', 'Review', 'en', 'intermediate', 35, 150, 30,
'## Developers: JavaScript Milestone Review

Congratulations! You have reached a major milestone in your CODEship Academy journey. Over the past 29 lessons you have gone from writing your first `console.log()` to building real web applications that fetch live data from the internet. That is extraordinary progress.

This lesson celebrates what you have achieved, reviews the key concepts, and prepares you for the exciting next chapter: Python.

### What You Have Learned

#### JavaScript Fundamentals (Lessons 1–10)
- **Variables** with `const` and `let`
- **Data types**: strings, numbers, booleans, null, undefined
- **Operators**: arithmetic, comparison, logical
- **Conditionals**: `if`, `else if`, `else`, ternary, `switch`
- **Functions**: declaration, expression, arrow functions, parameters, return values

#### DOM and Interactivity (Lessons 11–20)
- **Selecting elements**: `getElementById`, `querySelector`, `querySelectorAll`
- **Modifying content**: `textContent`, `innerHTML`, `style`, `classList`
- **Events**: `addEventListener`, click, keydown, submit, input
- **Creating elements**: `createElement`, `appendChild`, `insertBefore`
- **Forms**: reading input values, preventing default behavior, validation

#### Projects and CSS Mastery (Lessons 21–30)
- **To-Do List** — complete CRUD app with arrays and objects
- **Flexbox** — one-dimensional layouts, justify-content, align-items
- **CSS Grid** — two-dimensional layouts, template areas
- **Responsive Design** — mobile-first, media queries, fluid layouts
- **Animations** — transitions, `@keyframes`, timing functions
- **APIs** — fetch(), JSON, asynchronous code, `.then()`, `async/await`
- **JSON data** — parsing, navigating nested objects, looping, displaying in DOM
- **Weather App** — a full project combining all skills
- **Git** — version control, commits, branches, GitHub

### Mini-Quiz Walkthrough

Let''s review the most important concepts with practice questions.

**Question 1: What does this code output?**

```javascript
const numbers = [5, 12, 3, 8, 1];
const big = numbers.filter(n => n > 5);
console.log(big);
```

Answer: `[12, 8]` — filter keeps only items where the function returns true.

---

**Question 2: What is wrong with this code?**

```javascript
fetch("https://api.example.com/data")
  console.log(data.name);
```

Answer: Missing `.then()` — fetch is asynchronous. You must wait for the response before accessing data.

Correct:
```javascript
fetch("https://api.example.com/data")
  .then(r => r.json())
  .then(data => console.log(data.name));
```

---

**Question 3: Fix the flexbox to center the button horizontally AND vertically:**

```css
.container {
  height: 200px;
  /* your code here */
}
```

Answer:
```css
.container {
  height: 200px;
  display: flex;
  justify-content: center;
  align-items: center;
}
```

---

**Question 4: Which Git commands save your changes?**

Answer: `git add .` (stage) followed by `git commit -m "message"` (save snapshot).

---

**Question 5: What does this CSS media query do?**

```css
@media (min-width: 768px) {
  .sidebar { display: block; }
}
```

Answer: Shows the sidebar ONLY on screens 768px wide or wider (tablet and up). On mobile it stays hidden.

---

### Your Developer Toolkit So Far

| Skill | You Can Now... |
|-------|--------------|
| HTML | Build semantic, accessible page structures |
| CSS | Create beautiful, responsive layouts with Flexbox and Grid |
| JavaScript | Write functions, manipulate the DOM, handle events |
| APIs | Fetch live data from the internet |
| Git | Track your work and collaborate on GitHub |
| Projects | Build real, working apps from scratch |

### Common Mistakes and How to Avoid Them

**1. Forgetting `async/await` or `.then()`**
```javascript
// WRONG — fetch is async, this runs before data arrives
const data = fetch(url);

// RIGHT — wait for the data
const response = await fetch(url);
const data = await response.json();
```

**2. Forgetting `event.preventDefault()` on forms**
```javascript
form.addEventListener("submit", function(event) {
  event.preventDefault();   // ← never forget this!
  // ...your code
});
```

**3. Using `innerHTML` when you mean `textContent`**
```javascript
// RISKY — innerHTML can run scripts (security issue)
el.innerHTML = userInput;

// SAFE — textContent treats everything as plain text
el.textContent = userInput;
```

**4. Committing passwords or API keys**
- Always add `.env` to your `.gitignore`
- If you accidentally commit a key, rotate it immediately and never use that key again

### What is Coming Next: Python

In the next section of CODEship Academy you will learn Python — your second programming language. Python is famous for:

- **Readability** — code that looks like English
- **Data science** — analyzing and visualizing data
- **Automation** — scripting repetitive tasks
- **Artificial Intelligence** — machine learning and neural networks
- **Back-end web development** — servers with Django and Flask

The concepts you already know translate directly:

| JavaScript | Python |
|-----------|--------|
| `const x = 5` | `x = 5` |
| `console.log(x)` | `print(x)` |
| `// comment` | `# comment` |
| `function add(a, b) { return a + b; }` | `def add(a, b): return a + b` |
| `if (x > 5) { }` | `if x > 5:` |
| `for (let i = 0; i < 5; i++) { }` | `for i in range(5):` |

### Celebration Challenge

To celebrate your JavaScript milestone, build one of these mini-projects using everything you have learned:

**Option A: Memory Card Game**
- Create a grid of face-down cards
- Click two — if they match, they stay flipped
- Count moves and show the score

**Option B: Budget Tracker**
- Input income and expenses
- Display a running balance
- Color-code positive (green) and negative (red) balances
- Save to localStorage

**Option C: Quiz App**
- Array of question objects
- Show one question at a time
- Track score and show final results

### A Note on Your Progress

Learning to code is genuinely hard. You have written programs that would have looked like magic to you just a few weeks ago. Every bug you fixed, every concept that finally clicked — that is real learning happening.

Professional developers look things up. They use documentation. They make mistakes and fix them. The difference between a beginner and a professional is not perfection — it is persistence.

You are doing exactly what it takes.

### Key Takeaways

- You have mastered the full JavaScript front-end stack: HTML + CSS + JS + APIs + Git
- Review the mini-quiz questions to identify any gaps before moving on
- Python is next — your JavaScript foundation will make learning it much faster
- Build one of the celebration projects to solidify your skills
- You are ready for the next chapter. Let''s go!')

ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  instructions = EXCLUDED.instructions;
