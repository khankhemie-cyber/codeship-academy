-- =============================================================================
-- CODEship Academy — Builders Projects (bld-p01 to bld-p100)
-- =============================================================================

DO $$
DECLARE
  html_template TEXT := '<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Project</title>
  <style>
    /* Your styles go here */
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 20px;
    }
  </style>
</head>
<body>
  <!-- Your HTML goes here -->
  <h1>Hello, World!</h1>
</body>
</html>';

BEGIN

INSERT INTO projects (slug, title, level, category, starter_code, instructions, tags, xp_reward, sort_order) VALUES
('bld-p01', 'My First HTML Page', 'builders', 'HTML',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My First Page</title>
</head>
<body>
  <h1>Hello World!</h1>
  <p>This is my first HTML page.</p>
</body>
</html>',
'## My First HTML Page

Create a simple HTML page all about yourself!

### Steps:
1. Change the `<h1>` to say your name
2. Add a `<p>` paragraph about your favourite colour
3. Add another `<p>` about your favourite food
4. Add an `<h2>` that says "My Hobbies"
5. Add a `<ul>` list with 3 of your hobbies

### Bonus:
Add a `<footer>` with the date you made this page!',
ARRAY['html', 'beginner', 'personal'], 200, 1),

('bld-p02', 'All About Me Page', 'builders', 'HTML',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>All About Me</title>
</head>
<body>
  <h1>All About Me!</h1>
  <section>
    <h2>Who Am I?</h2>
    <p>Write about yourself here...</p>
  </section>
  <section>
    <h2>My Favourite Things</h2>
    <ul>
      <li>Item 1</li>
    </ul>
  </section>
</body>
</html>',
'## All About Me Page

Build a page telling the world all about you!

### What to include:
1. Your name as the main heading
2. A short introduction about yourself
3. Your favourite things (as a list)
4. Your favourite book or movie
5. A fun fact about yourself

### Remember:
- Use `<h1>` for the title
- Use `<h2>` for section headings
- Use `<p>` for paragraphs
- Use `<ul>` and `<li>` for lists',
ARRAY['html', 'beginner', 'personal'], 200, 2),

('bld-p03', 'Favourite Animal Fan Page', 'builders', 'HTML',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Favourite Animal</title>
</head>
<body>
  <h1>🐼 Giant Pandas!</h1>
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Grosser_Panda.JPG/330px-Grosser_Panda.JPG" alt="A giant panda eating bamboo" width="300">
  <h2>About Giant Pandas</h2>
  <p>Replace this with facts about your favourite animal!</p>
  <h2>Fun Facts</h2>
  <ul>
    <li>Add a fun fact here</li>
    <li>Add another fact here</li>
  </ul>
</body>
</html>',
'## Favourite Animal Fan Page

Create a fan page for your absolute favourite animal!

### Steps:
1. Change the heading to your favourite animal name
2. Find a free image of your animal (or keep the panda!)
3. Write 2-3 paragraphs of facts about the animal
4. Create a "Fun Facts" section with a bulleted list
5. Add a "Where do they live?" section with a description

### Use these HTML tags:
- `<h1>` — main title
- `<img>` — picture
- `<h2>` — section headings
- `<p>` — paragraphs
- `<ul>` and `<li>` — fun facts list',
ARRAY['html', 'images', 'beginner'], 200, 3),

('bld-p04', 'My Hobby Page with Lists and Links', 'builders', 'HTML',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Hobbies</title>
</head>
<body>
  <h1>My Favourite Hobbies</h1>
  <nav>
    <a href="#hobby1">Hobby 1</a> |
    <a href="#hobby2">Hobby 2</a> |
    <a href="#hobby3">Hobby 3</a>
  </nav>
  <section id="hobby1">
    <h2>Your First Hobby</h2>
    <p>Write about it here...</p>
  </section>
</body>
</html>',
'## My Hobby Page with Lists and Links

Build a page showcasing your top 3 hobbies!

### Requirements:
1. A title heading
2. A navigation bar with links to each hobby section (use `<a href="#id">`)
3. Three hobby sections, each with:
   - A heading (`<h2>`)
   - A description paragraph
   - A list of things you like about it
4. Use `id=""` attributes on sections so links work

### Challenge:
Add an ordered list (`<ol>`) of steps to start your hobby!',
ARRAY['html', 'links', 'lists', 'navigation'], 200, 4),

('bld-p05', 'School Schedule Table', 'builders', 'HTML',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My School Schedule</title>
</head>
<body>
  <h1>My School Schedule</h1>
  <table border="1">
    <thead>
      <tr>
        <th>Time</th>
        <th>Monday</th>
        <th>Tuesday</th>
        <th>Wednesday</th>
        <th>Thursday</th>
        <th>Friday</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>9:00 AM</td>
        <td>Math</td>
        <td>English</td>
        <td>Math</td>
        <td>Science</td>
        <td>Art</td>
      </tr>
      <tr>
        <td>10:00 AM</td>
        <td>Science</td>
        <td>Math</td>
        <td>History</td>
        <td>Math</td>
        <td>PE</td>
      </tr>
    </tbody>
  </table>
</body>
</html>',
'## School Schedule Table

Create an HTML table of your weekly school schedule!

### Steps:
1. The table should show your full week (Mon-Fri)
2. Each row is a time slot
3. Each cell shows the subject
4. Use `<thead>` for the header row
5. Use `<tbody>` for the data rows

### Table tags to use:
- `<table>` — the whole table
- `<thead>` / `<tbody>` — table sections
- `<tr>` — table row
- `<th>` — header cell (bold)
- `<td>` — data cell

### Bonus:
Use CSS to add colour to different subjects!',
ARRAY['html', 'tables', 'schedule'], 200, 5),

('bld-p06', 'Styled About Me Page', 'builders', 'CSS',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Styled About Me</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f0f4ff;
      color: #333;
      margin: 0;
      padding: 20px;
    }

    .container {
      max-width: 600px;
      margin: 0 auto;
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    h1 {
      color: #1E2140;
      /* Add more styles! */
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>About Me</h1>
    <p>I am a young coder learning to build amazing websites!</p>
    <p>My favourite colour is blue 💙</p>
  </div>
</body>
</html>',
'## Styled About Me Page

Take your About Me page and make it look amazing with CSS!

### What to style:
1. **Body**: Set a background colour and font
2. **Container**: Add a white box with rounded corners and a shadow
3. **Headings**: Change the colour and font size
4. **Paragraphs**: Adjust line spacing and font size
5. **Add a class**: Create a `.highlight` class for important text

### CSS properties to use:
- `background-color` — background colour
- `color` — text colour
- `font-family` — font style
- `font-size` — text size
- `border-radius` — round corners
- `box-shadow` — drop shadow
- `padding` — space inside elements
- `margin` — space outside elements',
ARRAY['css', 'styling', 'design'], 200, 6),

('bld-p07', 'Colour Palette Website', 'builders', 'CSS',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Colour Palette</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 20px;
    }
    .palette {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }
    .color-card {
      width: 120px;
      height: 120px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 12px;
      font-weight: bold;
      box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }
  </style>
</head>
<body>
  <h1>My Favourite Colours 🎨</h1>
  <div class="palette">
    <div class="color-card" style="background-color: #FF6B6B;">Coral Red</div>
    <div class="color-card" style="background-color: #4ECDC4;">Teal</div>
    <div class="color-card" style="background-color: #45B7D1;">Sky Blue</div>
    <!-- Add more colours! -->
  </div>
</body>
</html>',
'## Colour Palette Website

Create a beautiful colour palette display!

### Steps:
1. Start with the existing colour cards
2. Add at least 6 more colours
3. Change the text colour on light cards to black
4. Add the hex code below each colour name
5. Give each colour a fun name

### To find colours:
- Try colour names: `red`, `blue`, `gold`, `coral`, `teal`
- Try hex codes: `#FF5733`, `#1E2140`, `#F5C518`
- Try rgb: `rgb(100, 200, 50)`

### Bonus:
Group colours into a "Warm Colours" and "Cool Colours" section!',
ARRAY['css', 'colours', 'design'], 200, 7),

('bld-p08', 'Typography Showcase', 'builders', 'CSS',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=Playfair+Display:wght@700&family=Source+Code+Pro&display=swap" rel="stylesheet">
  <title>Typography</title>
  <style>
    body { font-family: Roboto, sans-serif; padding: 40px; max-width: 700px; margin: 0 auto; }
    h1 { font-family: "Playfair Display", serif; font-size: 48px; color: #1E2140; }
    h2 { font-size: 28px; color: #3A3D5C; }
    .code-sample { font-family: "Source Code Pro", monospace; background: #f5f5f5; padding: 16px; border-radius: 8px; }
    .large { font-size: 24px; }
    .small { font-size: 12px; }
    .italic { font-style: italic; }
    .bold { font-weight: 700; }
  </style>
</head>
<body>
  <h1>Typography is Art!</h1>
  <h2>This is a Subtitle</h2>
  <p class="large">Large text is easy to read.</p>
  <p>Normal text paragraph. Typography is the art of making text look great.</p>
  <p class="small">Small text for captions and footnotes.</p>
  <p class="italic">Italic text adds emphasis.</p>
  <p class="bold">Bold text is important!</p>
  <div class="code-sample">console.log("Code font looks professional!");</div>
</body>
</html>',
'## Typography Showcase

Explore the art of typography with CSS!

### What to build:
1. Display different font families (serif, sans-serif, monospace)
2. Show different font sizes from tiny to huge
3. Demonstrate bold, italic, and underline
4. Show different line heights and letter spacing
5. Create a "Do" and "Don''t" section for typography

### CSS properties to explore:
- `font-family` — which font to use
- `font-size` — how big the text is
- `font-weight` — bold (700) or regular (400)
- `font-style` — italic
- `line-height` — space between lines
- `letter-spacing` — space between letters
- `text-transform` — UPPERCASE, lowercase, Capitalize
- `text-decoration` — underline, line-through',
ARRAY['css', 'typography', 'fonts'], 200, 8),

('bld-p09', 'Box Model Demonstration', 'builders', 'CSS',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>The CSS Box Model</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 30px; background: #f5f5f5; }

    .demo-box {
      background-color: #4ECDC4;
      color: white;
      width: 200px;
      height: 100px;
      padding: 20px;
      border: 5px solid #1E2140;
      margin: 30px;
      border-radius: 8px;
    }

    .label {
      font-size: 12px;
      color: #666;
      margin-top: 5px;
    }
  </style>
</head>
<body>
  <h1>The CSS Box Model</h1>
  <p>Every element is a box! Try changing the values below.</p>

  <div class="demo-box">
    I am a box!
  </div>
  <p class="label">Try changing padding, margin, border, and size!</p>
</body>
</html>',
'## Box Model Demonstration

Show how the CSS box model works!

### Create 4 boxes showing:
1. **Content** — the actual content inside
2. **Padding** — space between content and border (try `padding: 30px`)
3. **Border** — the outline (try `border: 3px solid blue`)
4. **Margin** — space outside the box (try `margin: 20px`)

### Steps:
1. Create 4 divs
2. Give each one different padding values
3. Give each one a different coloured border
4. Use different margin values
5. Add labels explaining each property

### CSS to practise:
```css
.box {
  padding: 20px;        /* inside space */
  border: 3px solid red; /* outline */
  margin: 15px;         /* outside space */
  width: 200px;
  height: 100px;
}
```',
ARRAY['css', 'box-model', 'layout'], 200, 9),

('bld-p10', 'Card Collection', 'builders', 'CSS',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Card Collection</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 20px; background: #f0f4ff; }

    .cards {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
    }

    .card {
      background: white;
      border-radius: 16px;
      padding: 20px;
      width: 200px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      transition: transform 0.2s;
    }

    .card:hover {
      transform: translateY(-4px);
    }

    .card-emoji { font-size: 40px; margin-bottom: 10px; }
    .card-title { font-weight: bold; font-size: 18px; color: #1E2140; }
    .card-desc { font-size: 14px; color: #666; margin-top: 8px; }
  </style>
</head>
<body>
  <h1>My Collection 🃏</h1>
  <div class="cards">
    <div class="card">
      <div class="card-emoji">🚀</div>
      <div class="card-title">Space</div>
      <div class="card-desc">Rockets and stars and galaxies!</div>
    </div>
    <!-- Add more cards! -->
  </div>
</body>
</html>',
'## Card Collection

Build a beautiful collection of cards!

### Requirements:
- At least 6 cards
- Each card has: emoji, title, and description
- Cards arranged in a row (use flexbox)
- Cards wrap to next line on small screens
- Hover effect on each card

### Ideas for collections:
- Favourite movies
- Dream vacation spots
- Animals you love
- Superhero powers
- Favourite foods

### CSS skills:
- `display: flex` and `flex-wrap: wrap`
- `border-radius` for rounded corners
- `box-shadow` for depth
- `transition` and `transform` for hover effects',
ARRAY['css', 'cards', 'flexbox', 'hover'], 200, 10)
ON CONFLICT (slug) DO NOTHING;

-- Continue with projects 11-100
INSERT INTO projects (slug, title, level, category, starter_code, instructions, tags, xp_reward, sort_order) VALUES
('bld-p11', 'Flexbox Navigation Bar', 'builders', 'CSS', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Nav Bar</title><style>body{margin:0;font-family:Arial,sans-serif;}.nav{display:flex;background:#1E2140;padding:0 20px;}.nav a{color:white;text-decoration:none;padding:16px 20px;}.nav a:hover{background:#F5C518;color:#1E2140;}.nav .brand{font-weight:bold;font-size:20px;color:#F5C518;display:flex;align-items:center;}.spacer{flex:1;}</style></head><body><nav class="nav"><span class="brand">MySite</span><span class="spacer"></span><a href="#">Home</a><a href="#">About</a><a href="#">Projects</a><a href="#">Contact</a></nav><main style="padding:40px"><h1>Welcome to my site!</h1></main></body></html>',
'## Flexbox Navigation Bar

Build a professional navigation bar using Flexbox!

### Requirements:
1. Logo on the left
2. Navigation links on the right
3. Active link styling (different colour)
4. Hover effects on links
5. Sticky header (stays at top when scrolling)

### CSS to use:
```css
nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
```

### Bonus:
Add a hamburger menu icon for mobile!',
ARRAY['css', 'flexbox', 'navigation'], 200, 11),

('bld-p12', 'Photo Grid with Flexbox', 'builders', 'CSS', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Photo Grid</title><style>body{font-family:Arial,sans-serif;padding:20px;background:#111;color:white;}.grid{display:flex;flex-wrap:wrap;gap:8px;}.photo{width:calc(33.33% - 6px);aspect-ratio:1;background:#333;border-radius:8px;overflow:hidden;display:flex;align-items:center;justify-content:center;font-size:40px;}.photo:hover{opacity:0.8;cursor:pointer;}</style></head><body><h1>📸 My Photo Gallery</h1><div class="grid"><div class="photo">🌊</div><div class="photo">🌲</div><div class="photo">🏔️</div><div class="photo">🌸</div><div class="photo">🦋</div><div class="photo">🌅</div></div></body></html>',
'## Photo Grid with Flexbox

Create a photo grid layout like Instagram!

### Steps:
1. Create a 3-column grid of photos
2. Each photo should be square (equal width and height)
3. Add a hover effect (darken or zoom)
4. Make it responsive (2 columns on small screens)
5. Add captions that appear on hover

### Key CSS:
```css
.grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.photo {
  width: calc(33.33% - 6px);
  aspect-ratio: 1;
}
```',
ARRAY['css', 'flexbox', 'grid', 'gallery'], 200, 12)
ON CONFLICT (slug) DO NOTHING;

-- Insert remaining projects 13-100 with minimal content
INSERT INTO projects (slug, title, level, category, starter_code, instructions, tags, xp_reward, sort_order)
SELECT
  'bld-p' || LPAD(n::text, 2, '0'),
  title,
  'builders',
  category,
  '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>' || title || '</title><style>body{font-family:Arial,sans-serif;padding:20px;}</style></head><body><h1>' || title || '</h1><p>Start building your project here!</p></body></html>',
  '## ' || title || E'\n\nBuild this project using your HTML and CSS skills!\n\n### Steps:\n1. Plan your layout\n2. Write the HTML structure\n3. Add CSS styling\n4. Test in your browser\n5. Add any extra features\n\n### Remember:\n- Use semantic HTML\n- Write clean, readable CSS\n- Test on different screen sizes',
  ARRAY['builders', 'project'],
  200,
  n
FROM (VALUES
  (13, 'Responsive Card Layout', 'CSS'),
  (14, 'CSS Grid Magazine Layout', 'CSS'),
  (15, 'Personal Homepage', 'HTML'),
  (16, 'Animated Button Collection', 'CSS'),
  (17, 'CSS Art: Landscape Scene', 'CSS'),
  (18, 'Product Card with Hover', 'CSS'),
  (19, 'Gradient Hero Section', 'CSS'),
  (20, 'Multi-page Portfolio Site', 'HTML'),
  (21, 'Scratch Pong Game', 'Scratch'),
  (22, 'Scratch: Whack-a-Mole', 'Scratch'),
  (23, 'Scratch: Space Shooter', 'Scratch'),
  (24, 'Scratch: Maze Runner', 'Scratch'),
  (25, 'Scratch: Story with 3 Scenes', 'Scratch'),
  (26, 'Blog Post Page', 'HTML'),
  (27, 'Recipe Card Page', 'HTML'),
  (28, 'Book Review Page', 'HTML'),
  (29, 'Animated Loading Spinner', 'CSS'),
  (30, 'Dark Mode Card UI', 'CSS'),
  (31, 'CSS Accordion', 'CSS'),
  (32, 'Pricing Table', 'CSS'),
  (33, 'Timeline Component', 'CSS'),
  (34, 'Profile Card with Avatar', 'CSS'),
  (35, 'Responsive Image Gallery', 'CSS'),
  (36, 'Navigation with Dropdown', 'CSS'),
  (37, 'CSS Tooltip System', 'CSS'),
  (38, 'Sticky Header Layout', 'CSS'),
  (39, 'Mobile App Screenshot Page', 'CSS'),
  (40, 'Builders Portfolio Mid-Check', 'HTML'),
  (41, 'News Article Layout', 'HTML'),
  (42, 'Event Invitation Page', 'HTML'),
  (43, 'School Project Page', 'HTML'),
  (44, 'Band/Artist Fan Page', 'HTML'),
  (45, 'CSS Grid Dashboard Layout', 'CSS'),
  (46, 'CSS Art: Character Portrait', 'CSS'),
  (47, 'Contact Form Page', 'HTML'),
  (48, 'Animated Progress Bars', 'CSS'),
  (49, 'Restaurant Homepage', 'HTML'),
  (50, 'Travel Destination Page', 'HTML'),
  (51, 'Sports Team Fan Page', 'HTML'),
  (52, 'Science Fair Project Page', 'HTML'),
  (53, 'CSS Pixel Art', 'CSS'),
  (54, 'Animated Hero Banner', 'CSS'),
  (55, 'Team Member Card Grid', 'CSS'),
  (56, 'Accessible Form Design', 'HTML'),
  (57, 'CSS Variables Theme Switcher', 'CSS'),
  (58, 'Step-by-Step Recipe Page', 'HTML'),
  (59, 'Photo Blog Layout', 'HTML'),
  (60, 'CSS 3D Card Flip', 'CSS'),
  (61, 'Movie Review Page', 'HTML'),
  (62, 'Charity/Non-profit Page', 'HTML'),
  (63, 'Scratch: Multi-Level Platformer', 'Scratch'),
  (64, 'Scratch: Fishing Game', 'Scratch'),
  (65, 'Scratch: Musical Instrument', 'Scratch'),
  (66, 'Scratch: Digital Greeting Card', 'Scratch'),
  (67, 'Scratch: Memory Card Game', 'Scratch'),
  (68, 'CSS Skeleton Loading Screen', 'CSS'),
  (69, 'Notification Badge Component', 'CSS'),
  (70, 'Builders Portfolio Final', 'HTML'),
  (71, 'Responsive Product Page', 'HTML'),
  (72, 'CSS Pure Hamburger Menu', 'CSS'),
  (73, 'Music Album Page', 'HTML'),
  (74, 'App Landing Page', 'HTML'),
  (75, 'CSS Custom Scrollbar Demo', 'CSS'),
  (76, 'Video Embed Page', 'HTML'),
  (77, 'Infographic Layout', 'CSS'),
  (78, 'Quiz Results Page', 'HTML'),
  (79, 'Testimonials Section', 'CSS'),
  (80, 'Feature Comparison Table', 'CSS'),
  (81, 'Newsletter Signup Page', 'HTML'),
  (82, 'FAQ Accordion Page', 'CSS'),
  (83, 'CSS Sticker Maker', 'CSS'),
  (84, 'Winter Holiday Page', 'HTML'),
  (85, 'Nature Photography Page', 'HTML'),
  (86, 'Animated SVG Banner', 'CSS'),
  (87, 'Podcast Show Page', 'HTML'),
  (88, 'Vehicle Comparison Page', 'HTML'),
  (89, 'CSS Art: City Skyline', 'CSS'),
  (90, 'Accessible Navigation Demo', 'HTML'),
  (91, 'Job Listings Page', 'HTML'),
  (92, 'Course Catalogue Page', 'HTML'),
  (93, 'CSS Print-Ready CV', 'CSS'),
  (94, 'Interactive Map Key', 'CSS'),
  (95, 'E-commerce Product Grid', 'CSS'),
  (96, 'Developer Portfolio Starter', 'HTML'),
  (97, 'Builders Capstone: Full Website', 'HTML'),
  (98, 'Peer Code Review', 'HTML'),
  (99, 'Builders Showcase Presentation', 'HTML'),
  (100, 'Builders Graduation Project', 'HTML')
) AS t(n, title, category)
ON CONFLICT (slug) DO NOTHING;

END $$;
