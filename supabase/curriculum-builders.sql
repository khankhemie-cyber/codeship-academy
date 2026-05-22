-- =============================================================================
-- CODEship Academy — Builders Level Lessons (bld-l01 to bld-l30)
-- Target: Ages 8–11 | HTML, CSS, Scratch
-- =============================================================================

INSERT INTO lessons (slug, title, level, category, duration_minutes, xp_reward, sort_order, is_published, content)
VALUES

('bld-l01', 'Welcome to Builders Level', 'builders', 'HTML', 20, 100, 1, true,
'# Welcome to Builders Level! 🔨

You will learn to build real websites using HTML and CSS.

## Your First Webpage

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My First Page</title>
</head>
<body>
  <h1>Hello, World!</h1>
  <p>I am learning to build websites!</p>
</body>
</html>
```

### Breaking it down:
- `<!DOCTYPE html>` — tells the browser this is HTML
- `<html lang="en">` — the root element
- `<head>` — information about the page (not visible)
- `<meta charset="UTF-8">` — supports all characters
- `<meta name="viewport">` — makes it look right on phones
- `<title>` — text shown in the browser tab
- `<body>` — everything shown on the page

## Try It!

1. Open the Code Lab
2. Type the HTML above exactly
3. Press Run to see your page
4. Change the `<h1>` text to your name
5. Add a second `<p>` about yourself'),

('bld-l02', 'HTML Text and Headings', 'builders', 'HTML', 25, 100, 2, true,
'# HTML Text and Headings

HTML has six levels of headings from `<h1>` (biggest) to `<h6>` (smallest).

```html
<h1>Main Title — only ONE per page!</h1>
<h2>Section Heading</h2>
<h3>Sub-section</h3>
```

## Paragraphs and Emphasis

```html
<p>This is a paragraph with a <strong>bold word</strong> and an <em>italic word</em>.</p>
<p>Second paragraph.<br>Line break inside a paragraph.</p>
```

## Lists

```html
<!-- Bullet list -->
<ul>
  <li>Apples</li>
  <li>Bananas</li>
</ul>

<!-- Numbered list -->
<ol>
  <li>Step one</li>
  <li>Step two</li>
</ol>
```

## Challenge

Build a page about your favourite animal with an `<h1>`, a list of 3 fun facts, and a description paragraph.'),

('bld-l03', 'HTML Links and Images', 'builders', 'HTML', 25, 100, 3, true,
'# HTML Links and Images

## Links

```html
<a href="https://example.com" target="_blank" rel="noopener noreferrer">Open in new tab</a>
<a href="about.html">Go to About page</a>
<a href="#section-id">Jump to section</a>
```

Always add `rel="noopener noreferrer"` with `target="_blank"` for security.

## Images

```html
<img src="cat.jpg" alt="A fluffy orange cat on a windowsill" width="400">
<img src="https://picsum.photos/400/300" alt="Random nature photo">
```

The `alt` attribute is REQUIRED for accessibility — screen readers read it aloud.

## Image Links

```html
<a href="https://example.com">
  <img src="logo.png" alt="Visit Example.com">
</a>
```

## Challenge

Build a "Favourite Websites" page with 3 links opening in new tabs and one image from picsum.photos.'),

('bld-l04', 'HTML Semantic Structure', 'builders', 'HTML', 25, 100, 4, true,
'# Semantic HTML — The Right Tag for the Right Job

Semantic HTML uses tags that describe their meaning, not just appearance.

```html
<body>
  <header>
    <h1>My Website</h1>
    <nav>
      <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/about">About</a></li>
      </ul>
    </nav>
  </header>

  <main>
    <article>
      <h2>My Post</h2>
      <p>Main content goes here.</p>
    </article>
    <aside>
      <p>Related links go here.</p>
    </aside>
  </main>

  <footer>
    <p>&copy; 2025 My Website</p>
  </footer>
</body>
```

Key tags: `<header>`, `<nav>`, `<main>`, `<article>`, `<section>`, `<aside>`, `<footer>`

Only ONE `<main>` per page!

## Challenge

Build a structured personal webpage using all the semantic tags above.'),

('bld-l05', 'HTML Tables', 'builders', 'HTML', 25, 100, 5, true,
'# HTML Tables — For Data

Tables display information in rows and columns, like a spreadsheet.

```html
<table>
  <caption>Class Schedule</caption>
  <thead>
    <tr>
      <th scope="col">Time</th>
      <th scope="col">Monday</th>
      <th scope="col">Tuesday</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>9:00 AM</td>
      <td>Math</td>
      <td>Science</td>
    </tr>
    <tr>
      <td>10:00 AM</td>
      <td>Art</td>
      <td>PE</td>
    </tr>
  </tbody>
</table>
```

`colspan="2"` makes a cell span 2 columns. `rowspan="2"` spans 2 rows.

**Important:** Use tables for data ONLY, not for page layout.

## Challenge

Build an HTML table showing your weekly schedule with at least 5 subjects.'),

('bld-l06', 'HTML Forms', 'builders', 'HTML', 30, 100, 6, true,
'# HTML Forms

Forms collect information from users.

```html
<form action="/submit" method="POST">
  <label for="name">Your Name:</label>
  <input type="text" id="name" name="name" placeholder="Alex" required>

  <label for="email">Email:</label>
  <input type="email" id="email" name="email" required>

  <label for="grade">Grade:</label>
  <select id="grade" name="grade">
    <option value="">Choose...</option>
    <option value="4">Grade 4</option>
    <option value="5">Grade 5</option>
  </select>

  <label for="message">Message:</label>
  <textarea id="message" name="message" rows="4"></textarea>

  <input type="checkbox" id="agree" name="agree" required>
  <label for="agree">I agree to the terms</label>

  <button type="submit">Send</button>
</form>
```

Always link `<label>` to `<input>` using matching `for` and `id`.

## Challenge

Build a contact form with name, email, subject dropdown, message, and submit button.'),

('bld-l07', 'Introduction to CSS', 'builders', 'CSS', 25, 100, 7, true,
'# Introduction to CSS

CSS (Cascading Style Sheets) controls how HTML looks.

## Adding CSS

```html
<!-- Best practice: external file -->
<link rel="stylesheet" href="styles.css">
```

## CSS Syntax

```css
/* selector { property: value; } */

h1 {
  color: navy;
  font-size: 32px;
}

.highlight {
  background-color: yellow;
}

#main-title {
  text-align: center;
}
```

Selectors: `element`, `.class`, `#id`, `nav a` (descendant)

## Common Properties

```css
color: #1E2140;
font-family: Arial, sans-serif;
font-size: 18px;
font-weight: bold;
background-color: #F4F4F8;
margin: 20px;
padding: 15px;
border: 2px solid navy;
border-radius: 8px;
text-decoration: none;
```

## Challenge

Style a webpage with custom colours, fonts, and spacing using a separate CSS file.'),

('bld-l08', 'CSS Box Model', 'builders', 'CSS', 30, 100, 8, true,
'# The CSS Box Model

Every HTML element is a box with 4 layers: content, padding, border, margin.

```
[ MARGIN [ BORDER [ PADDING [ CONTENT ] ] ] ]
```

## Setting Properties

```css
* { box-sizing: border-box; }  /* Always add this! */

.card {
  width: 300px;
  padding: 24px;           /* inside space */
  border: 2px solid navy;
  border-radius: 12px;
  margin: 16px;            /* outside space */
}

/* Shorthand: top right bottom left */
padding: 10px 20px 10px 20px;

/* Shorthand: top/bottom left/right */
padding: 10px 20px;

/* Centre horizontally */
margin: 0 auto;
```

## Why `box-sizing: border-box`?

Without it, `padding` is ADDED to `width` (confusing!).
With it, `padding` is INSIDE the `width` (makes sense!).

Always put `* { box-sizing: border-box; }` at the top of your CSS.

## Challenge

Build a card component with proper padding, border-radius, and margin.'),

('bld-l09', 'CSS Colors and Typography', 'builders', 'CSS', 25, 100, 9, true,
'# CSS Colors and Typography

## Colour Formats

```css
color: red;              /* named */
color: #1E2140;          /* hex (most common) */
color: rgb(30, 33, 64);  /* RGB */
color: rgba(30, 33, 64, 0.5); /* RGB + transparency */
```

## Backgrounds

```css
background-color: #F4F4F8;
background: linear-gradient(135deg, #1E2140, #3A3D5C);
background-image: url(''hero.jpg'');
background-size: cover;
background-position: center;
```

## Typography

```css
font-family: ''Arial'', sans-serif;
font-size: 18px;
font-weight: bold;  /* or 700 */
line-height: 1.6;
letter-spacing: 0.05em;
text-transform: uppercase;
```

## CSS Custom Properties (Variables)

```css
:root {
  --color-primary: #1E2140;
  --color-accent: #F5C518;
  --space-md: 16px;
}

h1 { color: var(--color-primary); }
.btn { background: var(--color-accent); }
```

## Challenge

Create a typography showcase using Google Fonts and CSS variables for your colour palette.'),

('bld-l10', 'CSS Flexbox Basics', 'builders', 'CSS', 30, 100, 10, true,
'# CSS Flexbox — Flexible Layouts

Flexbox arranges items in a row or column.

```css
.container {
  display: flex;
  flex-direction: row;          /* or column */
  justify-content: space-between; /* main axis alignment */
  align-items: center;           /* cross axis alignment */
  gap: 16px;
  flex-wrap: wrap;               /* items wrap if no room */
}
```

## justify-content options:
`flex-start` | `flex-end` | `center` | `space-between` | `space-around` | `space-evenly`

## align-items options:
`flex-start` | `flex-end` | `center` | `stretch`

## Centering Anything

```css
.centered {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}
```

## Navigation Bar

```css
nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 32px;
  background: #1E2140;
}
nav ul {
  display: flex;
  list-style: none;
  gap: 24px;
}
```

## Challenge

Build a responsive navigation bar using Flexbox: logo left, links right.'),

('bld-l11', 'CSS Grid Layout', 'builders', 'CSS', 30, 100, 11, true,
'# CSS Grid — Two-Dimensional Layouts

Grid controls both rows AND columns at the same time.

```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: auto 1fr auto;
  gap: 20px;
}
```

## Named Areas

```css
.page {
  display: grid;
  grid-template-areas:
    "header header"
    "sidebar content"
    "footer footer";
  grid-template-columns: 200px 1fr;
}

header  { grid-area: header; }
.sidebar { grid-area: sidebar; }
main    { grid-area: content; }
footer  { grid-area: footer; }
```

## Auto-Responsive Grid (No Media Queries!)

```css
.cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 16px;
}
```

## Challenge

Build a magazine layout: full-width header, 3-column article grid, sidebar, footer.'),

('bld-l12', 'CSS Hover and Transitions', 'builders', 'CSS', 25, 100, 12, true,
'# CSS Hover Effects and Transitions

## :hover

```css
button {
  background: navy;
  transition: all 0.3s ease;  /* add BEFORE hover */
}

button:hover {
  background: gold;
  transform: translateY(-2px);
}
```

## Transitions

```css
/* transition: property duration timing */
transition: background-color 0.3s ease;
transition: all 0.3s ease-out;
transition: transform 0.2s, box-shadow 0.2s;
```

## Transform

```css
transform: translateY(-4px);  /* move up */
transform: scale(1.05);       /* 5% bigger */
transform: rotate(45deg);     /* rotate */
```

## Card Hover Effect

```css
.card {
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  transition: transform 0.2s, box-shadow 0.2s;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.15);
}
```

## Challenge

Build 4 cards each with a different hover effect: colour change, lift, scale, border glow.'),

('bld-l13', 'CSS Positioning', 'builders', 'CSS', 25, 100, 13, true,
'# CSS Positioning

```css
position: static;    /* default, normal flow */
position: relative;  /* offset from normal position */
position: absolute;  /* relative to nearest positioned parent */
position: fixed;     /* fixed to the viewport */
position: sticky;    /* normal flow, then fixed when scrolled */
```

## Practical Examples

```css
/* Fixed navbar */
.navbar {
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 100;
}

/* Badge on a card */
.card { position: relative; }
.badge {
  position: absolute;
  top: -8px; right: -8px;
  width: 24px; height: 24px;
  border-radius: 50%;
  background: red;
  color: white;
}

/* Sticky sidebar */
.sidebar {
  position: sticky;
  top: 20px;
}
```

## z-index

Higher z-index = appears on top of other elements.

## Challenge

Build a page with: a fixed navbar, a sticky sidebar, and a card with an absolute badge.'),

('bld-l14', 'CSS Animations', 'builders', 'CSS', 25, 100, 14, true,
'# CSS Animations

## @keyframes

```css
@keyframes slideIn {
  from { transform: translateX(-100%); opacity: 0; }
  to   { transform: translateX(0);     opacity: 1; }
}

.element {
  animation: slideIn 0.5s ease forwards;
}
```

## Multiple Steps

```css
@keyframes bounce {
  0%   { transform: translateY(0); }
  25%  { transform: translateY(-20px); }
  50%  { transform: translateY(0); }
  75%  { transform: translateY(-10px); }
  100% { transform: translateY(0); }
}

.ball { animation: bounce 1s ease infinite; }
```

## Loading Spinner

```css
@keyframes spin {
  from { transform: rotate(0deg); }
  to   { transform: rotate(360deg); }
}

.spinner {
  width: 40px; height: 40px;
  border: 4px solid #f3f3f3;
  border-top-color: navy;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}
```

## Challenge

Create a loading spinner, a pulsing button, and a slide-in hero section.'),

('bld-l15', 'Responsive Design', 'CSS', 30, 100, 15, true,
'# Responsive Design — Every Screen Size

## The Viewport Meta Tag

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

Always include this! Without it, mobile browsers zoom out.

## Media Queries

```css
/* Mobile first: default styles for small screens */
.cards { grid-template-columns: 1fr; }

/* Tablet */
@media (min-width: 600px) {
  .cards { grid-template-columns: repeat(2, 1fr); }
}

/* Desktop */
@media (min-width: 1024px) {
  .cards { grid-template-columns: repeat(3, 1fr); }
}
```

## Common Breakpoints

- Mobile: up to 600px
- Tablet: 600px–1024px
- Desktop: 1024px+

## Fluid Images

```css
img { max-width: 100%; height: auto; }
```

## Challenge

Make a desktop layout fully responsive: 1 column on mobile, 2 on tablet, 3 on desktop.'),

('bld-l16', 'Building a Navigation Bar', 'builders', 'CSS', 30, 100, 16, true,
'# Professional Navigation Bar

## HTML

```html
<header>
  <nav class="navbar">
    <a href="/" class="logo">🚀 MySite</a>
    <button class="hamburger" id="menuBtn" aria-label="Open menu">☰</button>
    <ul class="nav-links" id="navLinks">
      <li><a href="/">Home</a></li>
      <li><a href="/about">About</a></li>
      <li><a href="/contact">Contact</a></li>
    </ul>
  </nav>
</header>
```

## CSS

```css
.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 32px;
  background: #1E2140;
  position: sticky;
  top: 0;
  z-index: 100;
}
.logo { color: #F5C518; font-size: 24px; font-weight: bold; text-decoration: none; }
.nav-links { display: flex; list-style: none; gap: 32px; }
.nav-links a { color: white; text-decoration: none; transition: color 0.2s; }
.nav-links a:hover { color: #F5C518; }
.hamburger { display: none; background: none; border: none; color: white; font-size: 24px; }

@media (max-width: 768px) {
  .hamburger { display: block; }
  .nav-links {
    display: none; flex-direction: column;
    position: absolute; top: 100%; left: 0; right: 0;
    background: #1E2140; padding: 16px;
  }
  .nav-links.open { display: flex; }
}
```

## JavaScript

```html
<script>
  document.getElementById(''menuBtn'').addEventListener(''click'', () => {
    document.getElementById(''navLinks'').classList.toggle(''open'');
  });
</script>
```

## Challenge

Build a complete responsive navbar for a personal portfolio site.'),

('bld-l17', 'CSS Variables', 'builders', 'CSS', 20, 100, 17, true,
'# CSS Custom Properties (Variables)

Define values once, use them everywhere. Change one line to update your whole site!

## Defining Variables

```css
:root {
  --color-primary: #1E2140;
  --color-accent: #F5C518;
  --color-bg: #F4F4F8;
  --color-text: #2B2D42;
  --font-body: ''Inter'', sans-serif;
  --space-md: 16px;
  --space-lg: 24px;
  --radius: 8px;
  --shadow: 0 2px 8px rgba(0,0,0,0.1);
}
```

## Using Variables

```css
body { background: var(--color-bg); color: var(--color-text); }
.btn { background: var(--color-accent); padding: var(--space-md); border-radius: var(--radius); }
.card { box-shadow: var(--shadow); }
```

## Dark Mode

```css
@media (prefers-color-scheme: dark) {
  :root {
    --color-bg: #1E2140;
    --color-text: #F4F4F8;
  }
}
```

## Challenge

Refactor a site to use CSS variables for all colours, spacing, and radii. Add dark mode support.'),

('bld-l18', 'CSS Pseudo-classes', 'builders', 'CSS', 20, 100, 18, true,
'# Pseudo-classes and Pseudo-elements

## Common Pseudo-classes

```css
a:hover   { color: gold; }
a:focus   { outline: 3px solid gold; }
a:visited { color: purple; }

input:focus   { border-color: navy; }
input:invalid { border-color: red; }
input:valid   { border-color: green; }

li:first-child { font-weight: bold; }
li:last-child  { margin-bottom: 0; }
li:nth-child(odd)  { background: #f5f5f5; }
li:nth-child(even) { background: white; }

div:not(.special) { opacity: 0.7; }
```

## Pseudo-elements

```css
p::first-letter { font-size: 3em; float: left; }
p::first-line   { font-weight: bold; }

/* Add decorative content without HTML */
.btn::before { content: "→ "; }

h2::after {
  content: "";
  display: block;
  width: 60px; height: 3px;
  background: gold;
  margin-top: 8px;
}
```

## Challenge

Style a table with zebra stripes using nth-child, and add decorative underlines to headings using ::after.'),

('bld-l19', 'Multi-Page Website', 'builders', 'HTML', 30, 100, 19, true,
'# Building a Multi-Page Website

## File Structure

```
my-site/
├── index.html
├── about.html
├── projects.html
├── contact.html
└── css/
    └── styles.css
```

## Shared Navigation

Copy to every page — only change the `href` of the active link:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Home — My Portfolio</title>
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>
  <header>
    <nav class="navbar">
      <a href="index.html" class="logo">🚀 Your Name</a>
      <ul class="nav-links">
        <li><a href="index.html" aria-current="page">Home</a></li>
        <li><a href="about.html">About</a></li>
        <li><a href="projects.html">Projects</a></li>
        <li><a href="contact.html">Contact</a></li>
      </ul>
    </nav>
  </header>

  <main>
    <!-- PAGE CONTENT HERE -->
  </main>

  <footer>
    <p>&copy; 2025 Your Name</p>
  </footer>
</body>
</html>
```

## Challenge

Build a 4-page portfolio: Home (hero + skills), About, Projects (3 cards), Contact (form). All pages share nav + footer.'),

('bld-l20', 'CSS Hero Sections', 'builders', 'CSS', 25, 100, 20, true,
'# Hero Sections and Background Images

## Full-Height Hero

```css
.hero {
  min-height: 100vh;
  background: linear-gradient(135deg, #1E2140, #3A3D5C);
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  color: white;
}
```

## Photo Hero with Overlay

```css
.hero {
  position: relative;
  background-image: url(''hero.jpg'');
  background-size: cover;
  background-position: center;
}

.hero::before {
  content: "";
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
}

.hero-content {
  position: relative;
  z-index: 1;
  color: white;
}
```

## Gradient Hero

```css
.hero {
  background: linear-gradient(
    135deg,
    #1E2140 0%,
    #3A3D5C 50%,
    #F5C518 100%
  );
}
```

## Challenge

Build 3 hero sections: dark photo overlay, gradient, and a geometric CSS pattern.'),

('bld-l21', 'Web Accessibility', 'builders', 'Accessibility', 25, 100, 21, true,
'# Web Accessibility

Everyone deserves to use the web! In Canada, AODA requires accessible websites.

## Key Rules

### 1. Semantic HTML
```html
<button>Submit</button>  <!-- screen reader says "Submit, button" -->
<nav>...</nav>           <!-- screen reader announces "navigation" -->
```

### 2. Alt Text
```html
<img src="chart.png" alt="Bar chart showing 75% prefer coding">
<img src="divider.png" alt="">  <!-- decorative: empty alt -->
```

### 3. Form Labels
```html
<label for="email">Email</label>
<input type="email" id="email" required aria-describedby="hint">
<p id="hint">We will never share your email.</p>
```

### 4. Focus Styles
```css
/* NEVER remove focus outlines */
:focus-visible {
  outline: 3px solid #F5C518;
  outline-offset: 2px;
}
```

### 5. Skip Links
```html
<a href="#main" class="skip-link">Skip to content</a>
```

### 6. ARIA When Needed
```html
<button aria-expanded="false" aria-controls="menu">Menu</button>
<nav id="menu" aria-hidden="true">...</nav>
```

## Challenge

Audit your portfolio: keyboard-only navigation, alt text, proper labels, visible focus styles.'),

('bld-l22', 'Scratch Sprites and Backdrops', 'builders', 'Scratch', 25, 100, 22, true,
'# Scratch — Sprites and Backdrops

The stage is 480×360 pixels. Sprites are the characters; backdrops are backgrounds.

## First Script

```
When [🚩] clicked
  Say [Hello!] for [2] seconds
  Move [10] steps
```

## Moving with Arrow Keys

```
When [🚩] clicked
  Forever
    If [Right Arrow pressed?]
      Change x by [10]
    If [Left Arrow pressed?]
      Change x by [-10]
    If [Up Arrow pressed?]
      Change y by [10]
    If [Down Arrow pressed?]
      Change y by [-10]
```

## Costume Animation

```
When [🚩] clicked
  Forever
    Next Costume
    Wait [0.1] seconds
```

## Block Categories

- 🟡 Motion | 🟣 Looks | 🔵 Sound | 🟡 Events
- 🟠 Control | 🔵 Sensing | 🟢 Operators | 🔴 Variables

## Challenge

Build a Scratch project with a sprite that moves with arrow keys, animates between costumes, and says something when it touches the edge.'),

('bld-l23', 'Scratch Events and Control', 'builders', 'Scratch', 25, 100, 23, true,
'# Scratch — Events and Control

## Events

```
When [🚩] clicked
When [space] key pressed
When this sprite clicked
When I receive [message1]
```

## Control

```
Forever
Repeat [10]
Repeat Until [score = 0]

If [score > 10]
  Say [You win!]
Else
  Say [Keep going!]

Wait [2] seconds
Stop [all]
```

## Broadcasting

Sprites talk to each other with broadcasts:

```
/* Sprite 1 */
When [🚩] clicked
  Broadcast [start]

/* Sprite 2 */
When I receive [start]
  Show
  Go to x:[0] y:[0]
```

## Simple Quiz

```
When [🚩] clicked
  Set [score] to [0]
  Ask [What is 2 + 2?] and wait
  If [answer = "4"]
    Say [Correct!] for [2] seconds
    Change [score] by [1]
  Else
    Say [Not quite!] for [2] seconds
```

## Challenge

Build a 3-question quiz that keeps score and uses broadcasts between sprites.'),

('bld-l24', 'Scratch Variables and Score', 'builders', 'Scratch', 25, 100, 24, true,
'# Scratch Variables

Variables store values that can change — like score, lives, or time.

## Creating Variables

Variables tab → Make a Variable → name it → "For all sprites" or "For this sprite only"

## Key Blocks

```
Set [score] to [0]       -- give a specific value
Change [score] by [1]    -- add or subtract
Show variable [score]    -- display on stage
Hide variable [score]    -- hide from stage
```

## Score System

```
When [🚩] clicked
  Set [score] to [0]
  Set [lives] to [3]

When [this sprite] clicked
  Change [score] by [10]
  Play sound [pop]

When [🚩] clicked
  Forever
    If [lives = 0]
      Say [join [Game Over! Score: ] [score]]
      Stop [all]
```

## Timer Countdown

```
When [🚩] clicked
  Set [timer] to [30]
  Repeat [30]
    Wait [1] seconds
    Change [timer] by [-1]
  Broadcast [time up]
```

## Challenge

Build a game with score, lives, and a 30-second timer.'),

('bld-l25', 'CSS Flexbox Advanced', 'builders', 'CSS', 25, 100, 25, true,
'# CSS Flexbox — Advanced

## flex shorthand

```css
.item { flex: 1; }        /* grow:1 shrink:1 basis:0 */
.item { flex: 0 0 200px; } /* fixed 200px */
.item { flex: 2; }        /* twice as wide as flex:1 */
```

## Wrap Pattern for Cards

```css
.cards {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}

.card {
  flex: 1 1 280px;  /* min 280px, grows to fill */
  max-width: 400px;
}
```

## Sticky Footer

```css
body {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

main   { flex: 1; } /* pushes footer to bottom */
footer { /* stays at bottom automatically */ }
```

## align-self (override align-items for one item)

```css
.container { display: flex; align-items: center; }
.special   { align-self: flex-end; }
```

## Challenge

Build a photo gallery with flex-wrap, and a layout with a sticky footer.'),

('bld-l26', 'HTML Forms Advanced', 'builders', 'HTML', 25, 100, 26, true,
'# HTML Forms — Validation and Grouping

## HTML5 Built-in Validation

```html
<input type="text"     required minlength="3" maxlength="50">
<input type="number"   min="1" max="100">
<input type="email"    required>
<input type="url"      required>
<input type="date"     min="2020-01-01">
<input type="password" minlength="8">
<input type="text"     pattern="[A-Z]{3}[0-9]{3}"
       title="3 uppercase letters then 3 numbers">
```

## Styling Validation

```css
input:valid   { border-color: green; }
input:invalid { border-color: red; }
input:not(:placeholder-shown):invalid { border-color: red; }
```

## Fieldset Grouping

```html
<form>
  <fieldset>
    <legend>Personal Info</legend>
    <label for="fname">First Name</label>
    <input type="text" id="fname" name="fname" required>
  </fieldset>

  <fieldset>
    <legend>Account</legend>
    <label for="email">Email</label>
    <input type="email" id="email" name="email" required>
  </fieldset>

  <button type="submit">Register</button>
</form>
```

## Challenge

Build a multi-section registration form with client-side validation and error styling.'),

('bld-l27', 'Scratch Sensing', 'builders', 'Scratch', 25, 100, 27, true,
'# Scratch — Sensing Blocks

## Key Sensing Blocks

```
Touching [mouse pointer]?
Touching [Cat]?
Touching color [blue]?
Distance to [mouse pointer]
Mouse x, Mouse y
Mouse down?
Key [space] pressed?
Answer
Loudness
```

## Mouse Follower

```
When [🚩] clicked
  Forever
    Go to x:[mouse x] y:[mouse y]
```

## Collision

```
When [🚩] clicked
  Forever
    If [touching [Enemy]?]
      Change [lives] by [-1]
      Go to x:[0] y:[0]
```

## Ask and Answer

```
When [🚩] clicked
  Ask [What is your name?] and wait
  Say [join [Hello, ] [answer]] for [2] seconds
```

## Distance-Based Reaction

```
When [🚩] clicked
  Forever
    If [distance to [Player] < 50]
      Broadcast [danger]
```

## Challenge

Build an interactive Scratch story that: asks 3 questions, uses answers in the story, and has collision detection.'),

('bld-l28', 'CSS Grid Advanced', 'builders', 'CSS', 25, 100, 28, true,
'# CSS Grid — Advanced Layouts

## Spanning Items

```css
.featured { grid-column: span 2; }  /* 2 cols wide */
.banner   { grid-column: 1 / -1; } /* full width */
.tall     { grid-row: span 2; }     /* 2 rows tall */
```

## Template Areas (Complex Layouts)

```css
.page {
  display: grid;
  grid-template-areas:
    "header header header"
    "sidebar main ads"
    "footer footer footer";
  grid-template-columns: 180px 1fr 150px;
  min-height: 100vh;
}

header  { grid-area: header; }
.sidebar { grid-area: sidebar; }
main    { grid-area: main; }
.ads    { grid-area: ads; }
footer  { grid-area: footer; }

@media (max-width: 768px) {
  .page {
    grid-template-areas:
      "header"
      "main"
      "sidebar"
      "footer";
    grid-template-columns: 1fr;
  }
}
```

## Auto-Fill

```css
.gallery {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 16px;
}
```

## Challenge

Build a full magazine layout with grid-template-areas, responsive at all breakpoints.'),

('bld-l29', 'HTML Multimedia', 'builders', 'HTML', 20, 100, 29, true,
'# HTML Multimedia

## Video

```html
<video controls width="640" poster="thumbnail.jpg">
  <source src="video.mp4" type="video/mp4">
  <p>Your browser does not support video. <a href="video.mp4">Download it</a>.</p>
</video>

<!-- Background video (no controls) -->
<video autoplay muted loop playsinline>
  <source src="bg.mp4" type="video/mp4">
</video>
```

## Audio

```html
<audio controls>
  <source src="audio.mp3" type="audio/mpeg">
  <p>Your browser does not support audio.</p>
</audio>
```

## Responsive Images with `<picture>`

```html
<picture>
  <source media="(max-width: 600px)" srcset="small.jpg">
  <source media="(max-width: 1024px)" srcset="medium.jpg">
  <img src="large.jpg" alt="Description">
</picture>
```

## Figure and Figcaption

```html
<figure>
  <img src="chart.png" alt="Bar chart showing results">
  <figcaption>Fig. 1 — Results from our survey.</figcaption>
</figure>
```

## Challenge

Build a media page with a YouTube embed, audio player, responsive picture element, all in figure elements.'),

('bld-l30', 'Builders Level Portfolio', 'builders', 'HTML', 30, 100, 30, true,
'# Builders Level — Final Portfolio Project

You have mastered the foundations of web development! Time to show the world.

## What You Have Learned

### HTML ✅
Semantic structure, links, images, tables, forms, multimedia

### CSS ✅
Box model, colours, typography, Flexbox, Grid, transitions, animations, responsive design, variables, pseudo-classes

### Scratch ✅
Sprites, events, control, variables, sensing, broadcasting

## Final Project: Personal Portfolio

Build a 4-page website:

### Page 1: Home
- Full-height gradient hero with your name
- Skills grid (HTML, CSS, Scratch)
- 3 project preview cards

### Page 2: About
- Your story and interests
- Learning goals

### Page 3: Projects
- 6 project cards with hover effects
- Each card: title, description, link

### Page 4: Contact
- Full contact form with validation

### Requirements
- ✅ Responsive on all screen sizes
- ✅ CSS variables for colours
- ✅ Smooth hover transitions
- ✅ Semantic HTML throughout
- ✅ Accessible (alt text, focus styles, labels)
- ✅ Shared navigation and footer
- ✅ At least one CSS animation

You are a Builder. Now build something amazing! 🔨')

ON CONFLICT (slug) DO NOTHING;
