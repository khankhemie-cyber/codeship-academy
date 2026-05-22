-- =============================================================================
-- CODEship Academy — Builders Quizzes Q1–Q16
-- =============================================================================

INSERT INTO quizzes (slug, title, level, category, time_limit_seconds, passing_score, xp_reward) VALUES
('bld-q01', 'HTML Basics Quiz',             'builders', 'HTML',        600, 70, 150),
('bld-q02', 'HTML Text and Headings Quiz',  'builders', 'HTML',        600, 70, 150),
('bld-q03', 'HTML Links and Images Quiz',   'builders', 'HTML',        600, 70, 150),
('bld-q04', 'HTML Semantics Quiz',          'builders', 'HTML',        600, 70, 150),
('bld-q05', 'HTML Tables Quiz',             'builders', 'HTML',        600, 70, 150),
('bld-q06', 'HTML Forms Quiz',              'builders', 'HTML',        600, 70, 150),
('bld-q07', 'CSS Basics Quiz',              'builders', 'CSS',         600, 70, 150),
('bld-q08', 'CSS Box Model Quiz',           'builders', 'CSS',         600, 70, 150),
('bld-q09', 'CSS Colors and Fonts Quiz',    'builders', 'CSS',         600, 70, 150),
('bld-q10', 'CSS Flexbox Quiz',             'builders', 'CSS',         600, 70, 150),
('bld-q11', 'CSS Grid Quiz',                'builders', 'CSS',         600, 70, 150),
('bld-q12', 'CSS Transitions Quiz',         'builders', 'CSS',         600, 70, 150),
('bld-q13', 'CSS Positioning Quiz',         'builders', 'CSS',         600, 70, 150),
('bld-q14', 'Responsive Design Quiz',       'builders', 'CSS',         600, 70, 150),
('bld-q15', 'Accessibility Basics Quiz',    'builders', 'Accessibility', 600, 70, 150),
('bld-q16', 'Scratch Basics Quiz',          'builders', 'Scratch',     600, 70, 150)
ON CONFLICT (slug) DO NOTHING;

-- Q01: HTML Basics
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q01', 'What does HTML stand for?', '["HyperText Markup Language","HyperText Machine Language","HighText Markup Language","HyperText Making Language"]', 0, 'HTML = HyperText Markup Language.', 1),
  ('bld-q01', 'Which tag is the root of an HTML document?', '["<body>","<head>","<html>","<root>"]', 2, 'The <html> element is the root/parent of all other elements.', 2),
  ('bld-q01', 'Where does page content go?', '["<head>","<body>","<html>","<meta>"]', 1, 'The <body> contains everything visible on the page.', 3),
  ('bld-q01', 'What does the <title> tag do?', '["Shows a heading on the page","Sets the browser tab text","Creates a link","Adds metadata"]', 1, '<title> controls the text shown in the browser tab and bookmarks.', 4),
  ('bld-q01', 'Which meta tag is needed for mobile screens?', '["charset","author","description","viewport"]', 3, 'The viewport meta tag makes pages display correctly on mobile.', 5),
  ('bld-q01', 'What value should charset be set to?', '["UTF-8","ASCII","ISO-8859","UTF-16"]', 0, 'UTF-8 supports characters from all languages including accents.', 6),
  ('bld-q01', 'HTML tags are enclosed in:', '["{ }","[ ]","< >","( )"]', 2, 'HTML tags use angle brackets: <tagname>.', 7),
  ('bld-q01', 'An opening tag and closing tag together are called:', '["An attribute","An element","A property","A comment"]', 1, 'An HTML element consists of an opening tag, content, and a closing tag.', 8),
  ('bld-q01', 'Which is a correctly closed void element?', '["<img></img>","<img/>","<img>","</img>"]', 2, '<img> is a self-closing void element — no closing tag needed.', 9),
  ('bld-q01', 'HTML comments look like:', '["// comment","/* comment */","<!-- comment -->","## comment"]', 2, 'HTML comments use <!-- comment --> syntax.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q02: Text and Headings
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q02', 'How many heading levels does HTML have?', '["3","6","9","12"]', 1, 'HTML has 6 heading levels: <h1> through <h6>.', 1),
  ('bld-q02', 'Which heading is MOST important (largest)?', '["<h6>","<h3>","<h1>","<h0>"]', 2, '<h1> is the most important heading — only one per page!', 2),
  ('bld-q02', 'Which tag makes text bold AND important?', '["<b>","<bold>","<strong>","<em>"]', 2, '<strong> makes text bold and signals importance to screen readers.', 3),
  ('bld-q02', 'Which tag makes text italic/emphasized?', '["<i>","<em>","<italic>","<slant>"]', 1, '<em> adds emphasis (italic) and is understood by screen readers.', 4),
  ('bld-q02', 'How many <h1> tags should a page have?', '["As many as needed","Two","One","Zero"]', 2, 'A page should have exactly ONE <h1> for accessibility and SEO.', 5),
  ('bld-q02', 'Which tag creates a paragraph?', '["<para>","<pg>","<p>","<par>"]', 2, '<p> creates a paragraph with a gap above and below it.', 6),
  ('bld-q02', 'How do you create a line break INSIDE a paragraph?', '["<break>","<nl>","<br>","<lb>"]', 2, '<br> inserts a line break without starting a new paragraph.', 7),
  ('bld-q02', 'Which tag creates a bulleted list?', '["<ol>","<li>","<ul>","<bl>"]', 2, '<ul> = unordered list (bullets). <ol> = ordered list (numbers).', 8),
  ('bld-q02', 'What does <li> stand for?', '["List image","Line item","List item","Link item"]', 2, '<li> = list item. It goes inside <ul> or <ol>.', 9),
  ('bld-q02', 'Ordered lists use:', '["Bullet points","Numbers","Squares","Dashes"]', 1, '<ol> (ordered list) uses numbers by default.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q03: Links and Images
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q03', 'Which HTML tag creates a hyperlink?', '["<link>","<href>","<a>","<url>"]', 2, 'The <a> (anchor) tag creates hyperlinks.', 1),
  ('bld-q03', 'Which attribute defines the link destination?', '["src","url","link","href"]', 3, 'href (hypertext reference) specifies where a link goes.', 2),
  ('bld-q03', 'To open a link in a new tab, use:', '["target=''_new''","target=''_blank''","target=''new''","tab=''true''"]', 1, 'target="_blank" opens the link in a new tab.', 3),
  ('bld-q03', 'With target="_blank", you should also add:', '["rel=''nofollow''","rel=''noopener noreferrer''","rel=''external''","rel=''safe''"]', 1, 'rel="noopener noreferrer" prevents security vulnerabilities with new-tab links.', 4),
  ('bld-q03', 'Which tag displays an image?', '["<image>","<photo>","<img>","<pic>"]', 2, '<img> is the correct tag for displaying images.', 5),
  ('bld-q03', 'Which attribute specifies the image file?', '["href","link","src","url"]', 2, 'src (source) tells the browser where to find the image.', 6),
  ('bld-q03', 'The alt attribute is used for:', '["Image size","Alternative text for accessibility","Image title","Image link"]', 1, 'alt provides text description for screen readers and when images fail to load.', 7),
  ('bld-q03', 'A decorative image should have alt=""  because:', '["It is faster to load","Screen readers skip empty alt images","It saves bandwidth","It is required"]', 1, 'Empty alt="" tells screen readers to skip the image entirely (it adds no meaning).', 8),
  ('bld-q03', 'To link to a section on the same page, use:', '["<a href=''page.html''>","<a href=''#section-id''>","<a href=''top''>","<a jump=''true''>"]', 1, '#id creates an anchor link to a specific element on the same page.', 9),
  ('bld-q03', 'To make an image clickable, you:', '["Add onclick to the img","Wrap the img in an <a> tag","Add href to the img","Use a button"]', 1, 'Wrapping <img> in <a href="..."> makes the image a clickable link.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q04: Semantics
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q04', 'What is semantic HTML?', '["HTML with inline styles","Using tags that describe meaning","HTML that runs faster","HTML with comments"]', 1, 'Semantic HTML uses tags that describe the meaning and purpose of content.', 1),
  ('bld-q04', 'Which tag contains the site logo and nav?', '["<top>","<header>","<banner>","<heading>"]', 1, '<header> typically contains the logo, site title, and navigation.', 2),
  ('bld-q04', 'Which tag contains navigation links?', '["<links>","<menu>","<nav>","<navigation>"]', 2, '<nav> marks navigation menus.', 3),
  ('bld-q04', 'Where does the PRIMARY content go?', '["<section>","<content>","<main>","<body>"]', 2, '<main> holds the primary content. Only ONE per page.', 4),
  ('bld-q04', 'How many <main> elements should a page have?', '["As many as needed","Two","One","Three"]', 2, 'Only ONE <main> element per page for accessibility.', 5),
  ('bld-q04', 'Which tag is for a standalone piece of content (like a blog post)?', '["<section>","<article>","<div>","<aside>"]', 1, '<article> is for self-contained content that could stand alone.', 6),
  ('bld-q04', 'What is <aside> used for?', '["Secondary/sidebar content","The main content","The page header","Navigation"]', 0, '<aside> holds related but secondary content, like a sidebar.', 7),
  ('bld-q04', 'The <footer> typically contains:', '["The main navigation","The hero section","Copyright and links","The page title"]', 2, '<footer> contains copyright notices, secondary links, contact info.', 8),
  ('bld-q04', 'What does <section> do?', '["Groups unrelated content","Groups related content with a heading","Creates a new page","Makes content bold"]', 1, '<section> groups related content thematically, usually with a heading.', 9),
  ('bld-q04', 'Why prefer <button> over <div onclick="">?', '["Buttons look better","Buttons are keyboard and screen reader accessible","Buttons load faster","Div onclick is invalid"]', 1, '<button> is accessible by keyboard and announced correctly by screen readers.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q05: Tables
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q05', 'Which tag creates a table?', '["<tb>","<tbl>","<table>","<grid>"]', 2, '<table> is the container for the entire table.', 1),
  ('bld-q05', 'Which tag creates a table row?', '["<td>","<row>","<tr>","<th>"]', 2, '<tr> (table row) creates a horizontal row in a table.', 2),
  ('bld-q05', 'Which tag creates a header cell?', '["<td>","<th>","<header>","<tc>"]', 1, '<th> creates a header cell — bold and centred by default.', 3),
  ('bld-q05', 'Which tag creates a regular data cell?', '["<th>","<tc>","<cell>","<td>"]', 3, '<td> (table data) creates a regular cell in a table.', 4),
  ('bld-q05', 'Which element groups the header rows?', '["<thead>","<th>","<header>","<tgroup>"]', 0, '<thead> groups the header rows of a table.', 5),
  ('bld-q05', 'Which element groups the body rows?', '["<tbody>","<body>","<trows>","<tcontent>"]', 0, '<tbody> groups the main body rows of a table.', 6),
  ('bld-q05', 'The <caption> tag:', '["Styles the table","Adds a title/description to the table","Creates a header row","Makes text bold"]', 1, '<caption> gives the table a title, improving accessibility.', 7),
  ('bld-q05', 'colspan="3" means the cell:', '["Has 3 rows of height","Spans 3 columns","Has 3 border","Has 3em width"]', 1, 'colspan makes a cell span across multiple columns.', 8),
  ('bld-q05', 'Tables should be used for:', '["Page layouts","Navigation menus","Tabular data like schedules","Image galleries"]', 2, 'Tables are for data with rows and columns — not for layout!', 9),
  ('bld-q05', 'scope="col" on a <th> tells screen readers:', '["The cell is a column","This header applies to its column","This cell spans columns","The column is hidden"]', 1, 'scope="col" helps screen readers associate header cells with their columns.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q06: Forms
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q06', 'Which tag creates an HTML form?', '["<input>","<submit>","<form>","<field>"]', 2, '<form> is the container for all form elements.', 1),
  ('bld-q06', 'The action attribute on a form specifies:', '["The form style","Where the form data is sent","The form method","The form validation"]', 1, 'action is the URL where the form data is submitted.', 2),
  ('bld-q06', 'For sensitive data like passwords, use method:', '["GET","PUT","POST","SEND"]', 2, 'POST sends data in the request body (hidden). GET puts it in the URL.', 3),
  ('bld-q06', 'Which input type hides characters as you type?', '["hidden","text","secret","password"]', 3, 'type="password" hides the characters being typed.', 4),
  ('bld-q06', 'Which input type validates email format?', '["text","mail","email","address"]', 2, 'type="email" validates that the user enters a valid email format.', 5),
  ('bld-q06', 'The required attribute:', '["Formats the input","Makes the field mandatory","Hides the field","Styles the field"]', 1, 'required prevents form submission if the field is empty.', 6),
  ('bld-q06', 'A <label> should be connected to an input using:', '["class and name","for and id","name and id","href and src"]', 1, 'The label for attribute must match the input id attribute.', 7),
  ('bld-q06', 'Which element creates a multi-line text field?', '["<input type=''multiline''>","<field>","<textarea>","<multitext>"]', 2, '<textarea> creates a resizable multi-line text input.', 8),
  ('bld-q06', 'Which element creates a dropdown menu?', '["<dropdown>","<list>","<select>","<menu>"]', 2, '<select> with <option> elements creates a dropdown.', 9),
  ('bld-q06', 'Radio buttons differ from checkboxes because:', '["Radio buttons are round","Only one radio can be selected per group","Radio buttons are required","Radio buttons use id"]', 1, 'Radio buttons in the same name group allow only ONE selection.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q07: CSS Basics
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q07', 'What does CSS stand for?', '["Computer Style Sheets","Creative Style Syntax","Cascading Style Sheets","Coloured Style Sheets"]', 2, 'CSS = Cascading Style Sheets.', 1),
  ('bld-q07', 'The best way to add CSS is:', '["Inline styles","Internal <style> tag","External stylesheet","All are equally good"]', 2, 'External stylesheets (separate .css files) are the best practice.', 2),
  ('bld-q07', 'A CSS rule consists of:', '["Element and value","Selector, property, and value","Tag and class","Key and pair"]', 1, 'CSS rules: selector { property: value; }', 3),
  ('bld-q07', 'Which selector targets elements with class="card"?', '[".card","#card","card","*card"]', 0, 'Class selectors use a dot: .card', 4),
  ('bld-q07', 'Which selector targets the element with id="title"?', '["#title",".title","title","*title"]', 0, 'ID selectors use a hash: #title', 5),
  ('bld-q07', 'nav a selects:', '["All <a> elements","<a> elements inside <nav>","The <nav> element","<nav> and <a> elements"]', 1, 'Descendant selectors: nav a targets <a> elements that are inside <nav>.', 6),
  ('bld-q07', 'Which property changes text colour?', '["text-color","font-color","color","text"]', 2, 'The color property sets the text/foreground colour.', 7),
  ('bld-q07', 'Which property changes background colour?', '["color","background","bg-color","background-color"]', 3, 'background-color sets the background colour of an element.', 8),
  ('bld-q07', 'CSS comments use:', '["// comment","/* comment */","<!-- comment -->","## comment"]', 1, 'CSS comments use /* comment */ syntax.', 9),
  ('bld-q07', 'To link an external CSS file, use:', '["<style src=''file.css''>","<css href=''file.css''>","<link rel=''stylesheet'' href=''file.css''>","<script src=''file.css''>"]', 2, '<link rel="stylesheet" href="..."> links external CSS in the <head>.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q08: Box Model
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q08', 'What are the four layers of the CSS box model (outside to inside)?', '["margin, border, padding, content","padding, border, margin, content","content, padding, border, margin","border, padding, content, margin"]', 0, 'From outside: margin → border → padding → content.', 1),
  ('bld-q08', 'Padding is:', '["Space outside the border","Space between the border and content","The border itself","The background colour"]', 1, 'Padding is the space INSIDE the border, between the border and the content.', 2),
  ('bld-q08', 'Margin is:', '["Space inside the border","The border width","Space outside the border","The padding"]', 2, 'Margin is the space OUTSIDE the border, between the element and its neighbours.', 3),
  ('bld-q08', 'margin: 0 auto is used to:', '["Remove all margins","Centre an element horizontally","Add auto margins top and bottom","Set vertical margin"]', 1, 'margin: 0 auto centres a block element horizontally in its container.', 4),
  ('bld-q08', 'padding: 10px 20px sets:', '["All sides to 10px","Top/bottom 10px, left/right 20px","Left 10px, right 20px","Top 10px, bottom 20px"]', 1, 'Two values: first is top/bottom, second is left/right.', 5),
  ('bld-q08', 'box-sizing: border-box means:', '["Width includes border and padding","Width is just the content","Border is outside the width","Padding is outside the width"]', 0, 'border-box includes padding and border INSIDE the declared width.', 6),
  ('bld-q08', 'Without box-sizing: border-box, if width:200px and padding:20px, the actual width is:', '["200px","180px","240px","220px"]', 2, 'Default: width 200 + padding 20 + padding 20 = 240px total!', 7),
  ('bld-q08', 'border-radius: 50% on a square element creates:', '["A rectangle","A circle","A triangle","An oval"]', 1, 'border-radius: 50% on a square makes a perfect circle.', 8),
  ('bld-q08', 'border: 2px solid navy means:', '["2px gap, solid colour navy","2px thick solid border, navy colour","Navy background, 2px padding","2% border radius"]', 1, 'border shorthand: width style colour.', 9),
  ('bld-q08', 'The best practice is to put this at the top of every CSS file:', '["body { margin: 0; }","* { box-sizing: border-box; }","html { font-size: 16px; }","All of the above"]', 3, 'All three are common resets used at the top of CSS files.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q09: Colours and Fonts
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q09', 'Which is a valid hex colour?', '["#1E2140","#GGHHII","rgb(300,0,0)","hsl(400,50%,50%)"]', 0, 'Hex colours use 0-9 and A-F. #1E2140 is a valid dark navy colour.', 1),
  ('bld-q09', 'rgba(0, 0, 0, 0.5) means:', '["Black, 50% transparent","Red, green, blue all at 0","50% grey","Pure black"]', 0, 'RGBA: red=0, green=0, blue=0 (black), alpha=0.5 (50% transparent).', 2),
  ('bld-q09', 'CSS custom properties (variables) are defined on:', '[":root","body","html","head"]', 0, ':root targets the <html> element and makes variables available globally.', 3),
  ('bld-q09', 'How do you use a CSS variable named --color-primary?', '["color: --color-primary","color: var(--color-primary)","color: $color-primary","color: #{--color-primary}"]', 1, 'Use var(--variable-name) to reference a CSS custom property.', 4),
  ('bld-q09', 'Which font-family value is a fallback for fonts without serifs?', '["serif","cursive","sans-serif","monospace"]', 2, 'sans-serif is the generic fallback for fonts like Arial, Helvetica.', 5),
  ('bld-q09', 'font-weight: 700 is the same as:', '["light","normal","bold","extra-bold"]', 2, '700 = bold. 400 = normal. 300 = light. 900 = black.', 6),
  ('bld-q09', 'A comfortable line-height for body text is:', '["0.8","1.0","1.6","3.0"]', 2, 'line-height: 1.5 to 1.8 makes body text comfortable to read.', 7),
  ('bld-q09', 'linear-gradient(to right, red, blue) creates:', '["A gradient from top to bottom","A gradient from left (red) to right (blue)","A diagonal gradient","Alternating colours"]', 1, 'linear-gradient(to right, ...) goes left to right.', 8),
  ('bld-q09', 'text-transform: uppercase;', '["Makes text bigger","Makes all text UPPERCASE","Makes text bold","Hides text"]', 1, 'text-transform: uppercase converts all text to capital letters.', 9),
  ('bld-q09', 'letter-spacing adds space:', '["Between words","Between lines","Between letters","Around the element"]', 2, 'letter-spacing controls the space between individual characters.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q10: Flexbox
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q10', 'How do you enable Flexbox on a container?', '["flex: 1","display: flex","flex-direction: row","flex-container: true"]', 1, 'display: flex turns the element into a flex container.', 1),
  ('bld-q10', 'justify-content controls alignment along:', '["The cross axis","Both axes","The main axis","The z-axis"]', 2, 'justify-content aligns items along the main axis (horizontal in a row).', 2),
  ('bld-q10', 'align-items controls alignment along:', '["The main axis","The cross axis","Both axes","The z-axis"]', 1, 'align-items aligns items along the cross axis (vertical in a row).', 3),
  ('bld-q10', 'To centre items both horizontally and vertically:', '["justify-content: center","align-items: center","Both justify-content: center AND align-items: center","flex: center"]', 2, 'You need both justify-content: center and align-items: center.', 4),
  ('bld-q10', 'justify-content: space-between:', '["Items at the start","Equal space around all items","Items spread with space between them, none at edges","Items centred"]', 2, 'space-between puts space between items but not at the start or end.', 5),
  ('bld-q10', 'flex-direction: column makes items:', '["Go left to right","Stack vertically (top to bottom)","Go right to left","Wrap to next line"]', 1, 'flex-direction: column stacks items vertically instead of horizontally.', 6),
  ('bld-q10', 'flex-wrap: wrap allows items to:', '["Overlap each other","Wrap to the next line if no room","Shrink infinitely","Hide when too small"]', 1, 'flex-wrap: wrap allows items to move to the next line when they overflow.', 7),
  ('bld-q10', 'gap: 16px on a flex container:', '["Adds 16px padding inside each item","Adds 16px space between items","Adds 16px margin outside the container","Makes items 16px wide"]', 1, 'gap adds space between flex items without affecting outer margins.', 8),
  ('bld-q10', 'flex: 1 on an item means it:', '["Is 1px wide","Takes up 1 share of available space","Is always 100% wide","Stays at its natural size"]', 1, 'flex: 1 allows the item to grow and shrink to fill available space.', 9),
  ('bld-q10', 'flex: 0 0 200px means:', '["Grow and shrink, start at 200px","Do not grow, do not shrink, stay at 200px","200% of container","200 flex units"]', 1, 'flex: 0 0 200px = no grow, no shrink, fixed 200px size.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q11: Grid
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q11', 'How do you enable CSS Grid?', '["display: grid","grid: true","layout: grid","grid-container: on"]', 0, 'display: grid turns the element into a grid container.', 1),
  ('bld-q11', 'grid-template-columns: repeat(3, 1fr) creates:', '["3 columns of 1px each","3 equal columns","1 column repeated 3 times","3 rows"]', 1, 'repeat(3, 1fr) creates 3 equal columns using fractional units.', 2),
  ('bld-q11', '1fr means:', '["1 pixel","1 fraction of available space","1 flexbox unit","1 percentage"]', 1, 'fr = fraction unit. 1fr takes one share of available space.', 3),
  ('bld-q11', 'gap: 20px on a grid adds space:', '["Inside each cell","Between the grid and its container","Between rows and columns","Outside the grid"]', 2, 'gap adds space between grid cells (rows and columns).', 4),
  ('bld-q11', 'grid-column: 1 / -1 means:', '["Start at column 1, span 1","Start at column 1, end at the last column","From -1 to 1","Column 1 only"]', 1, '-1 refers to the last grid line, so 1/-1 spans the full width.', 5),
  ('bld-q11', 'grid-column: span 2 means:', '["Start at column 2","Span across 2 columns","Go to column 2","Skip 2 columns"]', 1, 'span 2 makes the item take up 2 column tracks.', 6),
  ('bld-q11', 'grid-template-areas is used for:', '["Drawing the grid lines","Naming and placing grid sections visually","Styling grid items","Creating grid gaps"]', 1, 'grid-template-areas lets you define layout visually using named areas.', 7),
  ('bld-q11', 'repeat(auto-fill, minmax(200px, 1fr)) creates:', '["Exactly 200 columns","As many 200px+ columns as fit, each growing to 1fr","A 200px fixed grid","One column of 200px"]', 1, 'auto-fill + minmax creates a responsive grid without media queries.', 8),
  ('bld-q11', 'Grid is best for:', '["One-dimensional layouts","Two-dimensional (rows AND columns) layouts","Animating elements","Styling text"]', 1, 'Grid excels at two-dimensional layouts; Flexbox is for one-dimensional.', 9),
  ('bld-q11', 'Flexbox vs Grid: which to use for a navbar?', '["Grid","Flexbox","Either works the same","Neither"]', 1, 'Flexbox is ideal for one-dimensional layouts like navbars and card rows.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q12: Transitions
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q12', 'The :hover pseudo-class applies styles when:', '["The element is clicked","The mouse cursor is over the element","The element is focused","The page loads"]', 1, ':hover applies when the mouse pointer is positioned over the element.', 1),
  ('bld-q12', 'Where should transition be placed?', '["On the :hover state","On the original element","In a @keyframes rule","In the :active state"]', 1, 'transition goes on the ORIGINAL element so it applies in both directions.', 2),
  ('bld-q12', 'transition: all 0.3s ease means:', '["All properties change instantly","All properties animate over 0.3 seconds with ease timing","Only 0.3 properties change","Ease by all 0.3"]', 1, 'Animates all changing properties over 0.3 seconds with ease timing.', 3),
  ('bld-q12', 'transform: scale(1.1) makes an element:', '["Move 1.1px","10% bigger","110% of viewport","Rotate 1.1 degrees"]', 1, 'scale(1.1) makes the element 10% larger than its original size.', 4),
  ('bld-q12', 'transform: translateY(-4px) moves an element:', '["4px to the right","4px down","4px up","4px to the left"]', 2, 'Negative Y value moves UP (Y axis goes down in CSS).', 5),
  ('bld-q12', 'The ease timing function:', '["Maintains constant speed","Starts slow, speeds up, ends slow","Starts fast, slows down","Is the same as linear"]', 1, 'ease (default) starts slow, accelerates, then decelerates at the end.', 6),
  ('bld-q12', 'linear timing function:', '["Starts slow","Maintains constant speed the whole way","Ends slow","Bounces at the end"]', 1, 'linear keeps the same animation speed from start to finish.', 7),
  ('bld-q12', 'transform: rotate(45deg) rotates:', '["45% of a circle","45 degrees clockwise","45 pixels","0.45 turns"]', 1, 'rotate(45deg) rotates the element 45 degrees clockwise.', 8),
  ('bld-q12', 'Multiple transforms on one element:', '["Require separate CSS rules","Are combined: transform: translateY(-4px) scale(1.05)","Only the last one applies","Are not possible"]', 1, 'Multiple transforms are combined in one transform property.', 9),
  ('bld-q12', 'box-shadow: 0 4px 16px rgba(0,0,0,0.2) creates:', '["A 4px border","A shadow offset down 4px, blurred 16px, semi-transparent","A 20% grey background","A 16px border radius"]', 1, 'box-shadow syntax: x-offset y-offset blur spread colour.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q13: Positioning
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q13', 'The default CSS position value is:', '["relative","absolute","fixed","static"]', 3, 'position: static is the default — elements follow normal page flow.', 1),
  ('bld-q13', 'position: fixed positions an element relative to:', '["Its parent","The body","The viewport (screen)","The nearest positioned parent"]', 2, 'Fixed elements stay in place on the screen when you scroll.', 2),
  ('bld-q13', 'position: absolute positions relative to:', '["The viewport","The body","The nearest ancestor with position != static","The document root"]', 2, 'Absolute elements are positioned relative to their nearest non-static ancestor.', 3),
  ('bld-q13', 'To use position: absolute on a child, the parent needs:', '["position: absolute","position: fixed","position: relative (or any non-static)","No special positioning"]', 2, 'The parent needs position: relative to become the containing block.', 4),
  ('bld-q13', 'position: sticky:', '["Is always fixed","Scrolls normally until reaching a threshold, then sticks","Is positioned relative to parent","Is the same as absolute"]', 1, 'Sticky elements scroll normally then "stick" when they hit the specified offset.', 5),
  ('bld-q13', 'z-index controls:', '["Horizontal position","Vertical position","Stacking order (which element appears on top)","Transparency"]', 2, 'Higher z-index values appear in front of (on top of) lower values.', 6),
  ('bld-q13', 'A fixed navbar at the top uses:', '["top: 0; left: 0; right: 0","margin: 0 auto","float: left","align: top"]', 0, 'top/left/right: 0 stretches the fixed element across the full top.', 7),
  ('bld-q13', 'inset: 0 is shorthand for:', '["z-index: 0","margin: 0","top: 0; right: 0; bottom: 0; left: 0","border: 0"]', 2, 'inset: 0 sets all four offset properties to 0 at once.', 8),
  ('bld-q13', 'An element with position: absolute; top: 0; right: 0 goes to:', '["Bottom left of parent","Top right of its containing block","Top left of page","Bottom right of viewport"]', 1, 'top:0, right:0 places it in the top-right corner of the positioned parent.', 9),
  ('bld-q13', 'To create a sticky header that stays at top while scrolling:', '["position: fixed; top: 0","position: sticky; top: 0","position: relative; top: 0","position: absolute; top: 0"]', 1, 'sticky + top:0 makes it stick to the top when you scroll past it.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q14: Responsive Design
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q14', 'Responsive design means:', '["Fast loading pages","Pages that look good on all screen sizes","Pages with animations","Pages in multiple languages"]', 1, 'Responsive design adapts layouts to work on any screen size.', 1),
  ('bld-q14', 'Which HTML tag is essential for mobile responsiveness?', '["<mobile>","<responsive>","<meta name=''viewport''>","<scale>"]', 2, 'The viewport meta tag prevents mobile browsers from zooming out.', 2),
  ('bld-q14', 'A media query lets you:', '["Query a database","Apply styles at specific screen widths","Play media files","Add audio to pages"]', 1, 'Media queries apply CSS rules based on device characteristics like width.', 3),
  ('bld-q14', '@media (min-width: 768px) applies when:', '["Screen is at most 768px wide","Screen is exactly 768px","Screen is at least 768px wide","Always"]', 2, 'min-width: 768px applies when the screen is 768px or wider.', 4),
  ('bld-q14', 'Mobile-first means:', '["Only design for mobile","Start with mobile styles, add larger screen styles with min-width queries","Design desktop first","Use max-width queries everywhere"]', 1, 'Mobile-first: default styles for mobile, add complexity with min-width queries.', 5),
  ('bld-q14', '@media (max-width: 600px) applies when:', '["Screen is 600px or wider","Screen is at most 600px wide","Screen is exactly 600px","Never"]', 1, 'max-width: 600px applies when the screen is 600px or narrower.', 6),
  ('bld-q14', 'To make images responsive, use:', '["width: 100%","max-width: 100%; height: auto","width: auto","img { responsive: true }"]', 1, 'max-width: 100% prevents images from overflowing, height: auto keeps aspect ratio.', 7),
  ('bld-q14', 'A common mobile breakpoint is:', '["200px","480px–600px","2000px","1px"]', 1, 'Common mobile breakpoints are around 480-600px.', 8),
  ('bld-q14', 'Viewport units vh and vw refer to:', '["Very high and very wide","Percentage of viewport height and width","Pixels","Virtual height and width"]', 1, 'vh = 1% of viewport height, vw = 1% of viewport width.', 9),
  ('bld-q14', 'The grid auto-fill pattern repeat(auto-fill, minmax(200px, 1fr)) creates:', '["A fixed 200px grid","A responsive grid without media queries","200 grid columns","A single column"]', 1, 'This powerful pattern creates a responsive grid that adapts without breakpoints.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q15: Accessibility
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q15', 'What does accessibility (a11y) mean?', '["Making sites load fast","Making sites usable by everyone including people with disabilities","Making sites look pretty","Making sites secure"]', 1, 'Accessibility ensures everyone can use your site, including users with disabilities.', 1),
  ('bld-q15', 'In Ontario, which law requires accessible websites?', '["PIPEDA","CASL","AODA","GDPR"]', 2, 'AODA (Accessibility for Ontarians with Disabilities Act) requires accessible sites.', 2),
  ('bld-q15', 'Screen readers are used by:', '["Slow internet users","Users who cannot see the screen","Mobile users","Users with slow computers"]', 1, 'Screen readers read page content aloud for blind or low-vision users.', 3),
  ('bld-q15', 'A decorative image should have:', '["No alt attribute","alt=''decorative''","alt=''''(empty string)","alt=''image''"]', 2, 'Empty alt="" tells screen readers to ignore the decorative image.', 4),
  ('bld-q15', 'Why must you never remove focus outlines?', '["They look bad","Keyboard users need them to see where they are","They slow the page","They are optional"]', 1, 'Focus outlines show keyboard users which element is currently focused.', 5),
  ('bld-q15', 'aria-label is used to:', '["Style elements","Provide an accessible name when no visible label exists","Link stylesheets","Create animations"]', 1, 'aria-label provides an accessible name for elements without visible text labels.', 6),
  ('bld-q15', 'A skip link helps:', '["SEO ranking","Keyboard users skip repetitive navigation","Load the page faster","Add animations"]', 1, 'Skip links let keyboard users jump past nav menus to the main content.', 7),
  ('bld-q15', 'Good colour contrast helps:', '["SEO","Users with low vision or colour blindness","Load speed","Animation performance"]', 1, 'Sufficient contrast makes text readable for users with low vision.', 8),
  ('bld-q15', 'WCAG 2.1 AA is:', '["A JavaScript framework","Web Content Accessibility Guidelines — the standard for accessible web","A CSS property","A browser extension"]', 1, 'WCAG 2.1 AA is the international standard for web accessibility.', 9),
  ('bld-q15', 'Using <button> instead of <div onclick=""> is better because:', '["Buttons have border-radius by default","Buttons are automatically keyboard-accessible and announced by screen readers","Buttons load faster","Divs cannot have onclick"]', 1, 'Native HTML interactive elements have built-in keyboard support and ARIA roles.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q16: Scratch Basics
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q16', 'In Scratch, the stage is:', '["Where sprites are coded","The area where your project runs and is visible","Where you find blocks","The sound editor"]', 1, 'The stage is the visual area (480×360) where your Scratch project plays.', 1),
  ('bld-q16', 'Sprites in Scratch are:', '["Background images","Characters and objects you can program","Sound files","Variables"]', 1, 'Sprites are the programmable characters and objects in your Scratch project.', 2),
  ('bld-q16', 'The "When green flag clicked" block:', '["Stops the project","Starts scripts when the green flag is clicked","Changes the backdrop","Deletes a sprite"]', 1, 'This is the most common event trigger — starts scripts when the project begins.', 3),
  ('bld-q16', 'The Forever block:', '["Runs a script once","Runs a script 10 times","Runs a script continuously until stopped","Stops all scripts"]', 2, 'Forever loops run its contained blocks over and over until the project stops.', 4),
  ('bld-q16', 'The If/Else block:', '["Runs code only once","Runs one set of blocks if condition is true, another if false","Waits for user input","Plays a sound"]', 1, 'If/Else checks a condition and runs different code based on the result.', 5),
  ('bld-q16', 'Scratch coordinates: x=0, y=0 is:', '["Top left corner","Top right corner","Centre of the stage","Bottom left corner"]', 2, 'In Scratch, (0,0) is the centre of the stage.', 6),
  ('bld-q16', 'To move a sprite right, you:', '["Change y by a positive number","Change x by a positive number","Change x by a negative number","Rotate 90 degrees"]', 1, 'Increasing x moves the sprite to the right.', 7),
  ('bld-q16', 'The Broadcast block is used to:', '["Play sounds","Send a message that other sprites can respond to","Show the score","Delete a clone"]', 1, 'Broadcast sends a message; "When I receive" blocks respond to it in any sprite.', 8),
  ('bld-q16', 'Costumes in Scratch are:', '["Different sprites","Different appearances of the same sprite","Background images","Sound files"]', 1, 'Costumes are different appearances/outfits for a single sprite.', 9),
  ('bld-q16', 'The Touching sprite? block is used for:', '["Playing sounds","Moving sprites","Detecting collision between sprites","Changing costumes"]', 2, 'Touching sprite? detects when two sprites are overlapping (collision detection).', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;
