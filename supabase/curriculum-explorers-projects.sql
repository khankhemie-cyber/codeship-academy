-- =============================================================================
-- CODEship Academy — Explorers Projects (exp-p01 to exp-p100)
-- Target: Ages 5–8 | Scratch, basic typing, digital citizenship
-- =============================================================================

INSERT INTO projects (slug, title, level, difficulty, duration_minutes, xp_reward, sort_order, is_published, description, instructions, starter_code, learning_objectives)
VALUES

('exp-p01', 'My Name in Lights', 'explorers', 'beginner', 20, 50, 1, true,
'Create a Scratch project that shows your name with colours and sounds!',
'1. Open Scratch and delete the cat sprite
2. Click "Choose a Sprite" and pick a letter sprite OR use the text tool
3. Add text showing your first name
4. Make each letter a different colour using the Looks blocks
5. Add a fun sound when the green flag is clicked
6. Add a backdrop that matches your favourite colour',
NULL,
ARRAY['Use Looks blocks to change colours', 'Add sounds to a project', 'Customise sprites and backdrops']),

('exp-p02', 'Animal Sound Board', 'explorers', 'beginner', 25, 50, 2, true,
'Build a Scratch sound board where clicking animals plays their sounds!',
'1. Choose 4 different animal sprites
2. Record or add animal sound effects for each
3. When each animal is clicked, it should:
   - Play its sound
   - Say its name for 2 seconds
   - Do a short animation (spin, bounce, or grow)
4. Add a fun backdrop like a zoo or jungle',
NULL,
ARRAY['Add click events to sprites', 'Play sounds in Scratch', 'Use the Say block', 'Animate sprites']),

('exp-p03', 'Moving Butterfly', 'explorers', 'beginner', 20, 50, 3, true,
'Create a butterfly that follows your mouse and flaps its wings!',
'1. Find or draw a butterfly sprite with 2 costumes (wings up, wings down)
2. Make it follow the mouse pointer
3. Make it switch costumes every 0.2 seconds (wing flapping!)
4. When it touches the edge, make it bounce back
5. Add a garden or meadow backdrop',
NULL,
ARRAY['Use the "go to mouse pointer" block', 'Animate with costume switching', 'Use the Forever loop', 'Detect edge collision']),

('exp-p04', 'Happy or Sad?', 'explorers', 'beginner', 20, 50, 4, true,
'Make a face sprite that reacts when you click it — happy or sad!',
'1. Draw a simple face sprite with 3 costumes: neutral, happy, sad
2. When the green flag is clicked, show the neutral face
3. When the sprite is clicked:
   - If it was happy, switch to sad and play a sad sound
   - If it was sad, switch to happy and play a happy sound
4. Add a variable "mood" to track happy vs sad',
NULL,
ARRAY['Use multiple costumes', 'Track state with a variable', 'Use if/else blocks', 'Add sound effects']),

('exp-p05', 'Catch the Star!', 'explorers', 'beginner', 30, 75, 5, true,
'A simple catching game — move your basket and catch falling stars!',
'1. Create a star sprite that starts at the top
2. Make the star fall down (change y by -5 in a forever loop)
3. When it hits the bottom, reset it to a random x position at the top
4. Create a basket sprite that moves left/right with arrow keys
5. When the star touches the basket:
   - Play a sound
   - Change score by 1
   - Reset star to top
6. Display the score on stage',
NULL,
ARRAY['Move sprites with arrow keys', 'Use random position', 'Detect sprite collision', 'Keep score with a variable']),

('exp-p06', 'My Week Story', 'explorers', 'beginner', 25, 50, 6, true,
'Create an animated story about your week using Scratch!',
'1. Plan 5 scenes (one for each school day)
2. Create a different backdrop for each day
3. Use a character sprite
4. For each scene, make the character say something interesting that happened
5. Use the "next backdrop" block to move between scenes
6. Add background music',
NULL,
ARRAY['Create multi-scene stories', 'Use backdrop switching', 'Control timing with Wait blocks', 'Plan a narrative']),

('exp-p07', 'Counting Game', 'explorers', 'beginner', 25, 50, 7, true,
'Build a counting game that teaches numbers 1-10!',
'1. Create number sprites (or use text) for 1-10
2. Arrange them randomly on the stage
3. Ask the player "Click on number ___!"
4. When they click the right number:
   - Say "Correct!" and play a happy sound
   - Show the next number challenge
5. Count how many correct answers and show the score',
NULL,
ARRAY['Use Ask and Answer blocks', 'Create interactive elements', 'Give feedback to player', 'Track progress']),

('exp-p08', 'Colour Mixing Experiment', 'explorers', 'beginner', 20, 50, 8, true,
'Create a Scratch art tool that mixes colours!',
'1. Create a white backdrop
2. Make a sprite that follows your mouse
3. When the mouse is down, change the pen colour and draw
4. Add 4 colour buttons (red, blue, yellow, green)
5. Clicking each button changes the drawing colour
6. Add a "Clear" button that wipes the canvas',
NULL,
ARRAY['Use the Pen extension', 'Create interactive buttons', 'Change properties dynamically', 'Build creative tools']),

('exp-p09', 'Weather Reporter', 'explorers', 'beginner', 20, 50, 9, true,
'Be a weather reporter! Create an animated weather forecast.',
'1. Create a character sprite (your weather reporter)
2. Create 4 weather backdrops: sunny, rainy, snowy, cloudy
3. When green flag clicked, character says "Today''s weather forecast:"
4. Switch to a random weather backdrop
5. Character says what the weather is and what to wear
6. After 5 seconds, switch to the next weather',
NULL,
ARRAY['Use random numbers', 'Switch backdrops', 'Use Say and Think blocks', 'Create narrative sequences']),

('exp-p10', 'Shape Drawing Tool', 'explorers', 'beginner', 25, 50, 10, true,
'Build a drawing tool that stamps shapes when you click!',
'1. Create button sprites for: circle, square, triangle, star
2. When each button is clicked, it broadcasts a shape message
3. Create a drawing sprite that receives the message
4. When a message is received, stamp that shape at the mouse position
5. Add colour buttons to change the stamp colour
6. Add a clear button',
NULL,
ARRAY['Use broadcast and receive', 'Use the Stamp block', 'Create button interactions', 'Build drawing tools']),

-- Projects 11-30: More Scratch projects with varied themes
('exp-p11', 'Alphabet Adventure', 'explorers', 'beginner', 25, 50, 11, true,
'Learn the alphabet with an interactive Scratch game!',
'Make a sprite say a word for each letter A-Z. When you press a letter key, show a picture and hear the word.',
NULL,
ARRAY['Use key pressed events', 'Display images for each letter', 'Play sounds', 'Create educational interactions']),

('exp-p12', 'Simple Calculator', 'explorers', 'beginner', 30, 75, 12, true,
'Build a basic adding calculator in Scratch!',
'Ask for two numbers and show the sum. Add buttons for +, -, ×.',
NULL,
ARRAY['Use Ask and Answer', 'Perform math operations', 'Display results', 'Create buttons']),

('exp-p13', 'Maze Runner', 'explorers', 'beginner', 35, 75, 13, true,
'Draw a maze and program a sprite to navigate it!',
'Design a maze backdrop. Program a sprite to move with arrow keys. Detect wall collisions. Add a goal!',
NULL,
ARRAY['Move with arrow keys', 'Detect colour collision', 'Build a complete game', 'Design levels']),

('exp-p14', 'Dance Party', 'explorers', 'beginner', 20, 50, 14, true,
'Create a Scratch dance party with multiple dancing sprites!',
'Add 3+ sprites. Make them dance (switch costumes). Add background music. Change colours on beat.',
NULL,
ARRAY['Coordinate multiple sprites', 'Synchronise animations', 'Use music timing', 'Create visual effects']),

('exp-p15', 'Guess My Number', 'explorers', 'beginner', 25, 50, 15, true,
'Program a number guessing game from 1 to 20!',
'Pick a random number. Ask player to guess. Say "too high", "too low", or "correct!" Count attempts.',
NULL,
ARRAY['Use random numbers', 'Use conditional logic', 'Count with variables', 'Give hints to player']),

('exp-p16', 'Pet Simulator', 'explorers', 'beginner', 30, 50, 16, true,
'Create a virtual pet that needs feeding and petting!',
'A pet sprite has hunger and happiness variables. Clicking "feed" or "pet" buttons changes the values.',
NULL,
ARRAY['Track multiple variables', 'Create interactive buttons', 'Simulate systems', 'Use conditional states']),

('exp-p17', 'Rock Paper Scissors', 'explorers', 'intermediate', 35, 75, 17, true,
'Build the classic Rock Paper Scissors game!',
'Player clicks rock, paper, or scissors. Computer picks randomly. Determine and announce the winner.',
NULL,
ARRAY['Use random pick', 'Create win conditions', 'Display results', 'Use if/else chains']),

('exp-p18', 'Space Explorer', 'explorers', 'beginner', 25, 50, 18, true,
'Create an animated space scene with a moving rocket!',
'Rocket flies across a starfield. Stars twinkle. Planets spin. Add asteroid obstacles.',
NULL,
ARRAY['Animate multiple sprites', 'Create parallax scrolling', 'Use random movement', 'Build atmosphere']),

('exp-p19', 'Story Builder', 'explorers', 'beginner', 25, 50, 19, true,
'Create a choose-your-own-adventure story!',
'Main character faces choices. Player clicks buttons to decide what happens next. Multiple endings!',
NULL,
ARRAY['Create branching narratives', 'Use button clicks for decisions', 'Track story state', 'Plan multiple paths']),

('exp-p20', 'Musical Instrument', 'explorers', 'beginner', 20, 50, 20, true,
'Build a virtual piano or drum kit in Scratch!',
'Create key sprites. When clicked/pressed, each plays a different note. Record a simple song.',
NULL,
ARRAY['Use the Sound extension', 'Map keys to sounds', 'Create musical patterns', 'Build interactive instruments']),

('exp-p21', 'Fruit Catcher', 'explorers', 'beginner', 30, 75, 21, true,
'Catch falling fruit — different fruits = different points!',
'Fruit falls at random x positions. Basket moves with mouse. Different fruits worth different points.',
NULL,
ARRAY['Use random spawn positions', 'Track score', 'Handle multiple sprite types', 'Increase difficulty']),

('exp-p22', 'Spelling Bee', 'explorers', 'beginner', 25, 50, 22, true,
'A spelling practice game for common words!',
'Show a picture, ask player to type the word. Give hints. Track score.',
NULL,
ARRAY['Use Ask for typed input', 'Check text answers', 'Show visual hints', 'Create educational feedback']),

('exp-p23', 'Traffic Light Controller', 'explorers', 'beginner', 20, 50, 23, true,
'Simulate a working traffic light in Scratch!',
'Traffic light cycles through red, yellow, green with correct timing. Cars stop and go.',
NULL,
ARRAY['Control timing with Wait blocks', 'Coordinate multiple sprites', 'Simulate real systems', 'Use broadcast messages']),

('exp-p24', 'Cookie Clicker', 'explorers', 'beginner', 20, 50, 24, true,
'Build a simple clicker game — click the cookie to earn cookies!',
'Click a cookie sprite to increase count. Use count to buy upgrades.',
NULL,
ARRAY['Count clicks with variables', 'Create upgrade systems', 'Display values on screen', 'Build addictive game loops']),

('exp-p25', 'Explorers Level Showcase', 'explorers', 'intermediate', 45, 100, 25, true,
'Your final Explorers project — show everything you have learned!',
'Build a complete Scratch project that includes: a sprite with multiple costumes, keyboard controls, score tracking, at least 2 scenes, and a win/lose condition.',
NULL,
ARRAY['Combine all learned skills', 'Create complete games', 'Show creativity', 'Build confidence as a coder']),

-- Projects 26-100: Structured entries
('exp-p26', 'Jumping Frog Game', 'explorers', 'intermediate', 35, 75, 26, true, 'Make a frog jump from lily pad to lily pad!', 'Use space bar to jump. Miss a lily pad = lose a life. Reach 10 lily pads to win!', NULL, ARRAY['Jumping mechanics', 'Platform games', 'Lives system']),
('exp-p27', 'Rainbow Painter', 'explorers', 'beginner', 20, 50, 27, true, 'Draw with rainbow colours that cycle automatically!', 'Pen changes colour as you draw. Fill the whole canvas!', NULL, ARRAY['Pen extension', 'Colour cycling', 'Creative tools']),
('exp-p28', 'Treasure Hunt Map', 'explorers', 'beginner', 25, 50, 28, true, 'Create an interactive treasure hunt map!', 'Click locations to discover clues. Find the treasure at the end!', NULL, ARRAY['Click detection', 'Sequential clues', 'Storytelling']),
('exp-p29', 'Animal Quiz', 'explorers', 'beginner', 25, 50, 29, true, 'Quiz players about animal facts!', '5 animal questions. Show the animal picture. Track score.', NULL, ARRAY['Quiz format', 'Answer checking', 'Score tracking']),
('exp-p30', 'Ballon Pop Game', 'explorers', 'beginner', 25, 50, 30, true, 'Click balloons before they float away!', 'Balloons appear at random positions. Click to pop them. Score points!', NULL, ARRAY['Random positioning', 'Click events', 'Time pressure']),
('exp-p31', 'Simon Says', 'explorers', 'intermediate', 35, 75, 31, true, 'Classic Simon Says memory game!', 'Coloured buttons light up in a sequence. Repeat the sequence!', NULL, ARRAY['Memory sequences', 'Increasing difficulty', 'Visual feedback']),
('exp-p32', 'Penguin Slide', 'explorers', 'beginner', 25, 50, 32, true, 'Slide the penguin down the ice slope!', 'Control speed with up/down. Avoid obstacles. Reach the bottom!', NULL, ARRAY['Momentum', 'Obstacle avoidance', 'Speed control']),
('exp-p33', 'Birthday Card Creator', 'explorers', 'beginner', 20, 50, 33, true, 'Make an animated birthday card!', 'Add a name, animate balloons and confetti, play happy birthday!', NULL, ARRAY['Animation', 'Personalisation', 'Creative project']),
('exp-p34', 'Bug Squisher', 'explorers', 'beginner', 25, 50, 34, true, 'Squish bugs before they reach your food!', 'Bugs move toward food. Click to squish. Miss 5 = game over!', NULL, ARRAY['Moving sprites', 'Click detection', 'Lose condition']),
('exp-p35', 'Number Line Jump', 'explorers', 'beginner', 20, 50, 35, true, 'Jump along a number line to solve math problems!', 'Ask a math problem. Show jumps on the number line. Reach the answer!', NULL, ARRAY['Visual math', 'Number sense', 'Educational games']),
('exp-p36', 'Underwater World', 'explorers', 'beginner', 25, 50, 36, true, 'Create an animated underwater scene!', 'Fish swim, bubbles float up, seaweed sways. Add a diver!', NULL, ARRAY['Continuous animation', 'Multiple sprite types', 'Scene building']),
('exp-p37', 'Sticker Book', 'explorers', 'beginner', 20, 50, 37, true, 'Build an interactive sticker book!', 'Click stickers to stamp them on the page. Resize and position them.', NULL, ARRAY['Stamping', 'Positioning', 'Creative expression']),
('exp-p38', 'Time Table Tester', 'explorers', 'beginner', 25, 50, 38, true, 'Test your times tables 1-12!', 'Random multiplication question. Check answer. Track score.', NULL, ARRAY['Math practice', 'Random questions', 'Correct/incorrect feedback']),
('exp-p39', 'Monster Maker', 'explorers', 'beginner', 25, 50, 39, true, 'Mix and match body parts to create monsters!', 'Click buttons to swap head, body, legs, arms. Create unique monsters!', NULL, ARRAY['Costume switching', 'Randomisation', 'Creative design']),
('exp-p40', 'Marble Run', 'explorers', 'intermediate', 35, 75, 40, true, 'Animate a marble rolling through a course!', 'Design ramps and obstacles. Animate marble bouncing and rolling.', NULL, ARRAY['Physics simulation', 'Animation paths', 'Course design']),
('exp-p41', 'Colour Sorter', 'explorers', 'beginner', 25, 50, 41, true, 'Sort coloured balls into matching buckets!', 'Drag coloured balls to the right buckets. Race against the clock!', NULL, ARRAY['Dragging sprites', 'Colour matching', 'Timed challenges']),
('exp-p42', 'Postcard Sender', 'explorers', 'beginner', 20, 50, 42, true, 'Design and send a virtual postcard!', 'Choose a background, add a stamp, write a message, animate sending.', NULL, ARRAY['Creative design', 'Text input', 'Multi-step interactions']),
('exp-p43', 'Plant Growth Timer', 'explorers', 'beginner', 20, 50, 43, true, 'Animate a plant growing through stages!', 'Show seed, sprout, small plant, full plant. Add watering animation!', NULL, ARRAY['Sequential animation', 'Growth simulation', 'Science learning']),
('exp-p44', 'Emoji Maker', 'explorers', 'beginner', 20, 50, 44, true, 'Create custom emojis by combining features!', 'Mix eyes, mouths, accessories to make unique emoji faces.', NULL, ARRAY['Layer combination', 'Creative expression', 'Design thinking']),
('exp-p45', 'Forest Fire Simulator', 'explorers', 'intermediate', 35, 75, 45, true, 'Simulate forest fire spreading and firefighters stopping it!', 'Trees can catch fire. Water from the firetruck puts it out.', NULL, ARRAY['Simulation', 'Cause and effect', 'Systems thinking']),
('exp-p46', 'Treasure Map Creator', 'explorers', 'beginner', 25, 50, 46, true, 'Draw your own treasure map with Scratch Pen!', 'Use pen blocks to draw landmasses, mark an X, add a compass.', NULL, ARRAY['Pen drawing', 'Creative maps', 'Coordinate system']),
('exp-p47', 'Weather Station', 'explorers', 'beginner', 25, 50, 47, true, 'Create an animated weather forecast station!', 'Display current weather with animation. Include temperature, conditions.', NULL, ARRAY['Data display', 'Weather simulation', 'UI design']),
('exp-p48', 'Jungle Safari', 'explorers', 'beginner', 25, 50, 48, true, 'Go on a virtual safari and spot animals!', 'Animals hide in the jungle. Find them by clicking the right spots!', NULL, ARRAY['Hidden object game', 'Click detection', 'Exploration']),
('exp-p49', 'Magic 8-Ball', 'explorers', 'beginner', 20, 50, 49, true, 'Build a Magic 8-Ball fortune teller!', 'Click the ball to shake it and reveal a random fortune message.', NULL, ARRAY['Random messages', 'Animation on click', 'List of options']),
('exp-p50', 'Explorers Mid-Point Challenge', 'explorers', 'intermediate', 45, 100, 50, true, 'Mid-point challenge: build a game with 3+ features learned so far!', 'Score, lives, timer, multiple sprites, collision detection, win/lose states.', NULL, ARRAY['Combine skills', 'Complete game mechanics', 'Creative problem solving']),

-- Projects 51-100 (abbreviated structures)
('exp-p51', 'Space Invaders Lite', 'explorers', 'intermediate', 40, 75, 51, true, 'Simple space invaders: shoot aliens before they land!', 'Spaceship moves left/right. Press space to fire. Aliens descend.', NULL, ARRAY['Shooting mechanics', 'Alien movement', 'Lives system']),
('exp-p52', 'Memory Card Game', 'explorers', 'intermediate', 40, 75, 52, true, 'Flip cards to match pairs!', '8 pairs of cards. Click to flip. Match all pairs to win!', NULL, ARRAY['Memory game logic', 'Card flipping', 'Match detection']),
('exp-p53', 'Dragon Flyer', 'explorers', 'beginner', 25, 50, 53, true, 'Fly a dragon through clouds!', 'Dragon flaps wings to stay aloft. Pass through cloud gaps.', NULL, ARRAY['Gravity simulation', 'Gap navigation', 'Flapping mechanic']),
('exp-p54', 'Hopscotch Game', 'explorers', 'beginner', 25, 50, 54, true, 'Virtual hopscotch on screen!', 'Numbered squares light up. Click in order. Beat the clock!', NULL, ARRAY['Sequential clicking', 'Timing', 'Order recognition']),
('exp-p55', 'Solar System Model', 'explorers', 'beginner', 30, 50, 55, true, 'Build an animated solar system model!', 'Sun in centre. Planets orbit at different speeds. Click for facts.', NULL, ARRAY['Circular motion', 'Scale models', 'Science learning']),
('exp-p56', 'Paint by Numbers', 'explorers', 'beginner', 25, 50, 56, true, 'Click numbered sections to paint by numbers!', 'Numbered areas fill with the right colour when clicked.', NULL, ARRAY['Click area detection', 'Colour filling', 'Patience and precision']),
('exp-p57', 'Sorting Hat', 'explorers', 'beginner', 20, 50, 57, true, 'A magical hat that sorts you into a group!', 'Ask name. Animate the hat. Announce a random result.', NULL, ARRAY['Randomisation', 'Animation', 'Input and output']),
('exp-p58', 'Food Chain Game', 'explorers', 'beginner', 25, 50, 58, true, 'Show the food chain — who eats who?', 'Drag animals to show predator-prey relationships.', NULL, ARRAY['Drag and drop', 'Science concepts', 'System relationships']),
('exp-p59', 'Rainstorm Simulator', 'explorers', 'beginner', 20, 50, 59, true, 'Make a rainstorm with lightning and thunder!', 'Rain drops fall. Lightning flashes. Thunder sounds after delay.', NULL, ARRAY['Weather simulation', 'Timing and delay', 'Multiple effects']),
('exp-p60', 'City Builder', 'explorers', 'intermediate', 40, 75, 60, true, 'Click to add buildings and grow your city!', 'Click empty lots to add houses, shops, parks. Track population.', NULL, ARRAY['City simulation', 'Resource management', 'Building placement']),
('exp-p61', 'Dino Runner', 'explorers', 'intermediate', 35, 75, 61, true, 'Endless runner — jump over obstacles!', 'Dino runs automatically. Press space to jump. Obstacles speed up.', NULL, ARRAY['Endless runner', 'Jumping', 'Speed increase']),
('exp-p62', 'Number Bonds', 'explorers', 'beginner', 25, 50, 62, true, 'Practice making numbers with number bonds!', 'Show a total. Click two numbers that add up to it.', NULL, ARRAY['Number bonds', 'Addition practice', 'Math games']),
('exp-p63', 'Ice Cream Shop', 'explorers', 'beginner', 25, 50, 63, true, 'Build an ice cream order simulator!', 'Choose cone, scoops, toppings. Show the final creation!', NULL, ARRAY['Multi-step selection', 'Display combination', 'Customer simulation']),
('exp-p64', 'Rhythm Game', 'explorers', 'intermediate', 35, 75, 64, true, 'Hit the beat! Press keys in rhythm!', 'Blocks fall toward targets. Press the right key at the right time.', NULL, ARRAY['Timing games', 'Key press detection', 'Beat matching']),
('exp-p65', 'Volcano Eruption', 'explorers', 'beginner', 25, 50, 65, true, 'Animate an exploding volcano!', 'Lava flows, ash clouds rise, rocks fly. Science in action!', NULL, ARRAY['Particle effects', 'Science animation', 'Multiple layers']),
('exp-p66', 'Submarine Adventure', 'explorers', 'beginner', 25, 50, 66, true, 'Guide a submarine through underwater caves!', 'Move sub with arrow keys. Avoid rocks. Collect treasure chests.', NULL, ARRAY['Navigation', 'Obstacle avoidance', 'Collection mechanics']),
('exp-p67', 'Fruit Salad Recipe', 'explorers', 'beginner', 20, 50, 67, true, 'Make a virtual fruit salad step by step!', 'Follow recipe steps. Click to add each fruit. Show the result!', NULL, ARRAY['Sequential steps', 'Recipe following', 'Cause and effect']),
('exp-p68', 'Alien Message Decoder', 'explorers', 'beginner', 25, 50, 68, true, 'Decode secret alien messages!', 'Replace symbols with letters to reveal the message. Then send a reply!', NULL, ARRAY['Symbol substitution', 'Pattern recognition', 'Code breaking']),
('exp-p69', 'Mini Golf', 'explorers', 'intermediate', 40, 75, 69, true, 'Play mini golf with a bouncing ball!', 'Aim with mouse. Click to set power. Ball bounces off walls.', NULL, ARRAY['Aiming mechanics', 'Bouncing physics', 'Mini golf logic']),
('exp-p70', 'Constellation Maker', 'explorers', 'beginner', 20, 50, 70, true, 'Draw constellations by connecting stars!', 'Stars appear on a dark backdrop. Drag to draw lines between them.', NULL, ARRAY['Drawing lines', 'Astronomy', 'Creative mapping']),
('exp-p71', 'Pond Life Simulator', 'explorers', 'beginner', 25, 50, 71, true, 'Simulate a pond ecosystem!', 'Frogs eat flies. Fish eat tadpoles. Balance the ecosystem.', NULL, ARRAY['Ecosystem simulation', 'Balance', 'Systems thinking']),
('exp-p72', 'Basketball Shooter', 'explorers', 'intermediate', 35, 75, 72, true, 'Shoot hoops — aim and click to shoot!', 'Ball arcs toward basket. Calculate the right angle. Score 3!', NULL, ARRAY['Trajectory', 'Angle calculation', 'Score tracking']),
('exp-p73', 'World Flags Quiz', 'explorers', 'beginner', 25, 50, 73, true, 'Guess the country from the flag!', '10 flags shown. Multiple choice answers. Track correct answers.', NULL, ARRAY['Quiz format', 'Multiple choice', 'World knowledge']),
('exp-p74', 'Caterpillar to Butterfly', 'explorers', 'beginner', 20, 50, 74, true, 'Animate the butterfly life cycle!', 'Egg → Caterpillar → Cocoon → Butterfly. Click to advance stages.', NULL, ARRAY['Life cycle animation', 'Sequential stages', 'Science learning']),
('exp-p75', 'Typing Trainer', 'explorers', 'beginner', 25, 50, 75, true, 'Practice typing with a fun Scratch game!', 'Letters fall down. Type them before they reach the bottom.', NULL, ARRAY['Keyboard detection', 'Typing practice', 'Speed challenge']),
('exp-p76', 'Museum Tour Guide', 'explorers', 'beginner', 25, 50, 76, true, 'Create a virtual museum tour!', 'Guide sprite leads player through 5 exhibits. Each has a fact.', NULL, ARRAY['Tour design', 'Information presentation', 'Scene switching']),
('exp-p77', 'Snail Race', 'explorers', 'beginner', 25, 50, 77, true, 'Race snails using button mashing!', 'Two players mash keys to make snails move. First to finish wins!', NULL, ARRAY['Two-player games', 'Button mashing mechanic', 'Race conditions']),
('exp-p78', 'Morning Routine Chart', 'explorers', 'beginner', 20, 50, 78, true, 'Interactive morning routine checklist!', 'Check off each morning task. Celebrate when all done!', NULL, ARRAY['Checklist logic', 'Celebration animations', 'Routine building']),
('exp-p79', 'Volcano Island Map', 'explorers', 'beginner', 25, 50, 79, true, 'Build an interactive island map with secrets!', 'Click different areas to discover facts. Find all 5 secrets!', NULL, ARRAY['Interactive maps', 'Click to reveal', 'Exploration design']),
('exp-p80', 'Penguin Ice Skater', 'explorers', 'beginner', 25, 50, 80, true, 'Control a sliding penguin on ice!', 'Penguin slides with momentum. Steer with arrow keys. Avoid cracks!', NULL, ARRAY['Momentum', 'Ice physics', 'Directional control']),
('exp-p81', 'Virtual Aquarium', 'explorers', 'beginner', 25, 50, 81, true, 'Build a virtual aquarium with animated fish!', '5+ fish species swim around. Click to learn about each.', NULL, ARRAY['Ambient animation', 'Click for information', 'Scene design']),
('exp-p82', 'Addition Race', 'explorers', 'beginner', 20, 50, 82, true, 'Race to solve addition problems!', 'Math problems appear. Type answer. Correct = car moves forward.', NULL, ARRAY['Math racing game', 'Speed vs accuracy', 'Progress representation']),
('exp-p83', 'Haunted House', 'explorers', 'intermediate', 35, 75, 83, true, 'Create a spooky haunted house interactive story!', 'Navigate rooms. Ghosts pop out. Find the escape route!', NULL, ARRAY['Navigation', 'Surprise elements', 'Room-based design']),
('exp-p84', 'Cloud Watcher', 'explorers', 'beginner', 20, 50, 84, true, 'Watch cloud shapes drift and change!', 'Clouds move across sky. Click to identify shapes. Add animals!', NULL, ARRAY['Drifting animation', 'Imagination', 'Nature observation']),
('exp-p85', 'Coin Sorter', 'explorers', 'beginner', 25, 50, 85, true, 'Sort Canadian coins — nickel, dime, quarter, loonie!', 'Coins appear randomly. Drag them to the right slot. Count the total.', NULL, ARRAY['Money recognition', 'Drag and drop', 'Canadian currency']),
('exp-p86', 'Build a Sandwich', 'explorers', 'beginner', 20, 50, 86, true, 'Stack sandwich ingredients in the right order!', 'Drag bread, fillings, toppings to build a sandwich layer by layer.', NULL, ARRAY['Drag and drop', 'Layer ordering', 'Food sequencing']),
('exp-p87', 'Sentence Builder', 'explorers', 'beginner', 25, 50, 87, true, 'Drag words to build correct sentences!', 'Scrambled words appear. Arrange them into a proper sentence.', NULL, ARRAY['Word ordering', 'Language learning', 'Drag and arrange']),
('exp-p88', 'Shadow Matching', 'explorers', 'beginner', 20, 50, 88, true, 'Match objects to their shadows!', 'Coloured objects on one side. Silhouettes on other. Drag to match.', NULL, ARRAY['Pattern matching', 'Shape recognition', 'Visual discrimination']),
('exp-p89', 'Pond Frogs Counting', 'explorers', 'beginner', 20, 50, 89, true, 'Count the frogs jumping into the pond!', 'Frogs jump in one by one. Count as they go. Answer the total.', NULL, ARRAY['Counting', 'Subitising', 'Number recognition']),
('exp-p90', 'Music Composer', 'explorers', 'beginner', 30, 50, 90, true, 'Compose a simple song by clicking note blocks!', 'A grid of note buttons. Click to toggle notes. Play your composition!', NULL, ARRAY['Music creation', 'Grid interaction', 'Pattern making']),
('exp-p91', 'Planet Fact Finder', 'explorers', 'beginner', 25, 50, 91, true, 'Click on planets to learn facts about our solar system!', 'Interactive solar system. Click each planet for a fact card.', NULL, ARRAY['Information display', 'Science learning', 'Interactive reference']),
('exp-p92', 'Dress-Up Game', 'explorers', 'beginner', 25, 50, 92, true, 'Mix and match clothes on a character!', 'Arrow buttons cycle through tops, bottoms, shoes, hats.', NULL, ARRAY['Costume cycling', 'Fashion design', 'Layer selection']),
('exp-p93', 'Dinosaur Facts', 'explorers', 'beginner', 25, 50, 93, true, 'Learn about dinosaurs with an interactive quiz!', 'Dinosaur appears. Click to see its name and a cool fact. Quiz at end!', NULL, ARRAY['Flashcard format', 'Prehistoric science', 'Fun facts']),
('exp-p94', 'Car Park Puzzle', 'explorers', 'intermediate', 35, 75, 94, true, 'Slide cars to let the red car escape!', 'Cars block the red car. Move them out of the way in the right order.', NULL, ARRAY['Sliding puzzle', 'Logical thinking', 'Problem solving']),
('exp-p95', 'Volcano Science Experiment', 'explorers', 'beginner', 20, 50, 95, true, 'Simulate a vinegar and baking soda volcano!', 'Click to add ingredients. Watch the reaction. Learn the science!', NULL, ARRAY['Chemistry concepts', 'Sequential steps', 'Science simulation']),
('exp-p96', 'Butterfly Life Cycle Quiz', 'explorers', 'beginner', 20, 50, 96, true, 'Put the butterfly life cycle stages in order!', 'Drag and drop: egg, larva, pupa, adult butterfly in correct order.', NULL, ARRAY['Life cycle knowledge', 'Ordering', 'Biology learning']),
('exp-p97', 'Dream House Builder', 'explorers', 'beginner', 30, 50, 97, true, 'Design your dream house by adding rooms and features!', 'Click rooms to add them: kitchen, bedroom, pool, garden. See the result!', NULL, ARRAY['Design choices', 'Accumulation', 'Creative vision']),
('exp-p98', 'Library Book Organiser', 'explorers', 'beginner', 25, 50, 98, true, 'Sort books by colour or size onto the correct shelf!', 'Books appear randomly. Drag to matching shelf. Level up with more books!', NULL, ARRAY['Categorisation', 'Drag and drop', 'Library skills']),
('exp-p99', 'Emergency Vehicle Race', 'explorers', 'beginner', 25, 50, 99, true, 'Race emergency vehicles to the scene!', 'Police car, ambulance, fire truck: choose the right one for each emergency.', NULL, ARRAY['Decision making', 'Community helpers', 'Selection matching']),
('exp-p100', 'Explorers Grand Finale', 'explorers', 'intermediate', 60, 150, 100, true,
'Your grand finale Explorers project! Build the most amazing Scratch project you can!',
'Combine EVERYTHING you have learned: multiple sprites, costumes, backdrops, variables, score, timer, events, broadcasts, sensing, and animations. Make us proud!',
NULL,
ARRAY['Master-level Scratch skills', 'Creative expression', 'Show all you have learned', 'Build something you are proud of'])

ON CONFLICT (slug) DO NOTHING;
