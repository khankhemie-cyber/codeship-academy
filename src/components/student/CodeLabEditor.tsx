'use client'

import { useState } from 'react'

interface Props {
  level: string
  isBlockBased: boolean
}

const STARTER_TEMPLATES: Record<string, string> = {
  html: `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Page</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 20px; background: #f4f4f8; }
    h1 { color: #1E2140; }
  </style>
</head>
<body>
  <h1>Hello, World!</h1>
  <p>Start coding here!</p>
</body>
</html>`,
  css: `/* CSS Playground */
body {
  font-family: Arial, sans-serif;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  margin: 0;
}

.box {
  background: white;
  padding: 40px;
  border-radius: 16px;
  text-align: center;
  box-shadow: 0 20px 60px rgba(0,0,0,0.2);
}`,
  javascript: `// JavaScript Playground
console.log('Hello from Code Lab!');

// Try changing these values:
const name = 'Coder';
const age = 10;

document.body.innerHTML = \`
  <h1 style="font-family:Arial;color:#1E2140">Hello, \${name}!</h1>
  <p style="font-family:Arial">You are \${age} years old.</p>
  <button onclick="alert('You clicked me!')"
    style="padding:10px 20px;background:#F5C518;border:none;border-radius:8px;font-size:16px;cursor:pointer">
    Click Me!
  </button>
\`;`,
}

const BLOCK_SCRATCH_MESSAGE = `
Scratch-style block coding is available through the Scratch website.
For now, use our text editor to practise HTML and CSS — the building blocks of the web!
`

export default function CodeLabEditor({ level, isBlockBased }: Props) {
  const [lang, setLang] = useState<'html' | 'css' | 'javascript'>('html')
  const [code, setCode] = useState(STARTER_TEMPLATES.html)
  const [previewKey, setPreviewKey] = useState(0)
  const [showPreview, setShowPreview] = useState(false)

  function handleLangChange(newLang: 'html' | 'css' | 'javascript') {
    setLang(newLang)
    setCode(STARTER_TEMPLATES[newLang])
    setShowPreview(false)
  }

  const previewDoc = lang === 'css'
    ? `<!DOCTYPE html><html><head><style>${code}</style></head><body><div class="box"><h2>CSS Preview</h2><p>Your styles are applied here.</p></div></body></html>`
    : lang === 'javascript'
    ? `<!DOCTYPE html><html><body><script>${code}<\/script></body></html>`
    : code

  return (
    <div className="h-full space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-gray-900">Code Lab</h1>
        <div className="flex items-center gap-2">
          <span className="text-xs text-gray-500 uppercase tracking-wide font-semibold">Language:</span>
          {(['html', 'css', 'javascript'] as const).map(l => (
            <button
              key={l}
              onClick={() => handleLangChange(l)}
              className={`px-3 py-1.5 rounded-lg text-sm font-medium uppercase tracking-wide transition-colors ${lang === l ? 'bg-brand-navy text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'}`}
            >
              {l}
            </button>
          ))}
        </div>
      </div>

      {isBlockBased && (
        <div className="card p-4 bg-blue-50 border border-blue-200">
          <p className="text-sm text-blue-800">
            🧩 <strong>Tip:</strong> Explorers level uses visual blocks on Scratch. This text editor is a bonus for when you want to try HTML!
          </p>
        </div>
      )}

      <div className="flex gap-4" style={{ height: 'calc(100vh - 260px)' }}>
        {/* Editor */}
        <div className="flex-1 flex flex-col">
          <div className="bg-gray-800 rounded-t-lg px-4 py-2 flex items-center justify-between">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-red-400" />
              <div className="w-3 h-3 rounded-full bg-yellow-400" />
              <div className="w-3 h-3 rounded-full bg-green-400" />
              <span className="text-xs text-gray-400 ml-2 font-mono">my-project.{lang === 'javascript' ? 'js' : lang}</span>
            </div>
            <button
              onClick={() => { setPreviewKey(k => k + 1); setShowPreview(true) }}
              className="text-xs bg-brand-gold text-brand-dark px-3 py-1 rounded font-bold hover:bg-yellow-400 transition-colors"
            >
              ▶ Run
            </button>
          </div>
          <textarea
            value={code}
            onChange={e => setCode(e.target.value)}
            className="flex-1 font-mono text-sm p-4 bg-gray-900 text-green-400 border border-gray-700 rounded-b-lg focus:outline-none resize-none leading-relaxed"
            spellCheck={false}
            aria-label="Code editor"
          />
        </div>

        {/* Preview */}
        <div className="flex-1 flex flex-col">
          <div className="bg-gray-100 rounded-t-lg px-4 py-2 border border-gray-200 flex items-center gap-2">
            <div className="w-3 h-3 rounded-full bg-red-300" />
            <div className="w-3 h-3 rounded-full bg-yellow-300" />
            <div className="w-3 h-3 rounded-full bg-green-300" />
            <span className="text-xs text-gray-500 ml-2">Preview</span>
          </div>
          <div className="flex-1 border border-gray-200 border-t-0 rounded-b-lg overflow-hidden bg-white">
            {showPreview ? (
              <iframe
                key={previewKey}
                srcDoc={previewDoc}
                sandbox="allow-scripts"
                className="w-full h-full"
                title="Code preview"
              />
            ) : (
              <div className="flex items-center justify-center h-full text-gray-400 text-sm flex-col gap-3">
                <span className="text-4xl">👁️</span>
                <p>Press <strong>▶ Run</strong> to see your code in action</p>
              </div>
            )}
          </div>
        </div>
      </div>

      <div className="flex gap-3">
        <button
          onClick={() => setCode(STARTER_TEMPLATES[lang])}
          className="btn-secondary text-sm"
        >
          Reset to Template
        </button>
        <a
          href={`data:text/plain;charset=utf-8,${encodeURIComponent(code)}`}
          download={`my-project.${lang === 'javascript' ? 'js' : lang}`}
          className="btn-secondary text-sm"
        >
          Download Code
        </a>
      </div>
    </div>
  )
}
