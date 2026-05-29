'use client'
import { useState, useRef, useEffect, useCallback } from 'react'
import { Play, Square, Trash2, RotateCcw, ChevronDown, ChevronRight, Rocket } from 'lucide-react'

// ─── Types ────────────────────────────────────────────────────────────────────
type BlockCategory = 'events' | 'motion' | 'looks' | 'control' | 'sound'

interface BlockDef {
  id: string
  category: BlockCategory
  label: string
  shape: 'hat' | 'stack' | 'c-block'
  inputs?: { id: string; type: 'number' | 'text' | 'select'; default: string | number; options?: string[] }[]
  color: string
}

interface ScriptBlock {
  uid: string
  defId: string
  inputs: Record<string, string | number>
}

interface Sprite {
  x: number; y: number; angle: number
  visible: boolean; saying: string | null; sayTimer: any
  penDown: boolean
}

// ─── Block Definitions ────────────────────────────────────────────────────────
const BLOCK_DEFS: BlockDef[] = [
  // Events
  { id: 'when_flag', category: 'events', label: '🚀 When launched', shape: 'hat', color: '#F59E0B' },
  { id: 'when_key', category: 'events', label: '⌨️ When [ ] key pressed', shape: 'hat', color: '#F59E0B', inputs: [{ id: 'key', type: 'select', default: 'space', options: ['space','up','down','left','right','a','b','c'] }] },

  // Motion
  { id: 'move', category: 'motion', label: '➡️ Move [ ] steps', shape: 'stack', color: '#3B82F6', inputs: [{ id: 'steps', type: 'number', default: 50 }] },
  { id: 'turn_right', category: 'motion', label: '↪️ Turn right [ ] degrees', shape: 'stack', color: '#3B82F6', inputs: [{ id: 'deg', type: 'number', default: 15 }] },
  { id: 'turn_left', category: 'motion', label: '↩️ Turn left [ ] degrees', shape: 'stack', color: '#3B82F6', inputs: [{ id: 'deg', type: 'number', default: 15 }] },
  { id: 'goto_xy', category: 'motion', label: '📍 Go to x: [ ] y: [ ]', shape: 'stack', color: '#3B82F6', inputs: [{ id: 'x', type: 'number', default: 0 }, { id: 'y', type: 'number', default: 0 }] },
  { id: 'goto_center', category: 'motion', label: '🎯 Go to centre', shape: 'stack', color: '#3B82F6' },
  { id: 'bounce', category: 'motion', label: '🔀 Bounce if at edge', shape: 'stack', color: '#3B82F6' },
  { id: 'glide', category: 'motion', label: '🌊 Glide [ ] secs to x:[ ] y:[ ]', shape: 'stack', color: '#3B82F6', inputs: [{ id: 'secs', type: 'number', default: 1 }, { id: 'x', type: 'number', default: 100 }, { id: 'y', type: 'number', default: 100 }] },

  // Looks
  { id: 'say', category: 'looks', label: '💬 Say [ ]', shape: 'stack', color: '#7C3AED', inputs: [{ id: 'msg', type: 'text', default: 'Hello!' }] },
  { id: 'say_secs', category: 'looks', label: '💬 Say [ ] for [ ] secs', shape: 'stack', color: '#7C3AED', inputs: [{ id: 'msg', type: 'text', default: 'Hello!' }, { id: 'secs', type: 'number', default: 2 }] },
  { id: 'show', category: 'looks', label: '👁️ Show', shape: 'stack', color: '#7C3AED' },
  { id: 'hide', category: 'looks', label: '🙈 Hide', shape: 'stack', color: '#7C3AED' },
  { id: 'grow', category: 'looks', label: '🔼 Grow by [ ]', shape: 'stack', color: '#7C3AED', inputs: [{ id: 'amount', type: 'number', default: 10 }] },
  { id: 'shrink', category: 'looks', label: '🔽 Shrink by [ ]', shape: 'stack', color: '#7C3AED', inputs: [{ id: 'amount', type: 'number', default: 10 }] },

  // Control
  { id: 'wait', category: 'control', label: '⏱️ Wait [ ] seconds', shape: 'stack', color: '#F59E0B', inputs: [{ id: 'secs', type: 'number', default: 1 }] },
  { id: 'repeat', category: 'control', label: '🔁 Repeat [ ] times', shape: 'c-block', color: '#F59E0B', inputs: [{ id: 'times', type: 'number', default: 3 }] },
  { id: 'forever', category: 'control', label: '♾️ Forever', shape: 'c-block', color: '#F59E0B' },
  { id: 'stop', category: 'control', label: '🛑 Stop all', shape: 'stack', color: '#EF4444' },
]

const CAT_META: Record<BlockCategory, { label: string; color: string; emoji: string }> = {
  events:  { label: 'Events',  color: '#F59E0B', emoji: '⚡' },
  motion:  { label: 'Motion',  color: '#3B82F6', emoji: '🚀' },
  looks:   { label: 'Looks',   color: '#7C3AED', emoji: '✨' },
  control: { label: 'Control', color: '#F59E0B', emoji: '🔁' },
  sound:   { label: 'Sound',   color: '#EC4899', emoji: '🔊' },
}

const sleep = (ms: number) => new Promise(r => setTimeout(r, ms))
let stopFlag = false

// ─── Main Component ───────────────────────────────────────────────────────────
export default function BlocksEnvironment() {
  const stageRef = useRef<HTMLCanvasElement>(null)
  const [script, setScript] = useState<ScriptBlock[]>([])
  const [running, setRunning] = useState(false)
  const [activeCategory, setActiveCategory] = useState<BlockCategory>('motion')
  const [openCategories, setOpenCategories] = useState<Record<string, boolean>>({ events: true, motion: true, looks: false, control: false })
  const [dragBlock, setDragBlock] = useState<{ defId: string; x: number; y: number } | null>(null)
  const [sprite, setSprite] = useState<Sprite>({ x: 0, y: 0, angle: 0, visible: true, saying: null, sayTimer: null, penDown: false })
  const [spriteSize, setSpriteSize] = useState(40)
  const spriteRef = useRef(sprite)
  const spriteSize$ = useRef(spriteSize)
  const [dropHighlight, setDropHighlight] = useState(false)
  const scriptAreaRef = useRef<HTMLDivElement>(null)

  // Keep refs in sync
  useEffect(() => { spriteRef.current = sprite }, [sprite])
  useEffect(() => { spriteSize$.current = spriteSize }, [spriteSize])

  // ─── Canvas render ─────────────────────────────────────────────────────────
  const drawStage = useCallback(() => {
    const canvas = stageRef.current
    if (!canvas) return
    const ctx = canvas.getContext('2d')!
    const W = canvas.width, H = canvas.height
    const sp = spriteRef.current
    const sz = spriteSize$.current

    ctx.clearRect(0, 0, W, H)

    // Grid background
    ctx.fillStyle = '#F8F9FE'
    ctx.fillRect(0, 0, W, H)
    ctx.strokeStyle = '#E8EAF6'
    ctx.lineWidth = 1
    for (let x = 0; x <= W; x += 40) { ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, H); ctx.stroke() }
    for (let y = 0; y <= H; y += 40) { ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(W, y); ctx.stroke() }

    // Centre crosshair
    ctx.strokeStyle = '#D0D3E8'
    ctx.setLineDash([4, 4])
    ctx.beginPath(); ctx.moveTo(W/2, 0); ctx.lineTo(W/2, H); ctx.stroke()
    ctx.beginPath(); ctx.moveTo(0, H/2); ctx.lineTo(W, H/2); ctx.stroke()
    ctx.setLineDash([])

    // Coordinate labels
    ctx.fillStyle = '#B0B4D0'; ctx.font = '10px monospace'
    ctx.fillText('(0,0)', W/2 + 4, H/2 - 4)

    if (!sp.visible) return

    const cx = W/2 + sp.x
    const cy = H/2 - sp.y

    // Say bubble
    if (sp.saying) {
      const padding = 10
      ctx.font = 'bold 13px Nunito, sans-serif'
      const tw = ctx.measureText(sp.saying).width
      const bw = tw + padding * 2, bh = 32
      const bx = cx + 16, by = cy - bh - 16
      ctx.fillStyle = 'white'
      ctx.strokeStyle = '#1E2140'
      ctx.lineWidth = 2
      ctx.beginPath()
      ctx.roundRect(bx, by, bw, bh, 8)
      ctx.fill(); ctx.stroke()
      // tail
      ctx.beginPath(); ctx.moveTo(bx + 12, by + bh); ctx.lineTo(cx + 8, cy - 8); ctx.lineTo(bx + 24, by + bh); ctx.closePath()
      ctx.fillStyle = 'white'; ctx.fill()
      ctx.strokeStyle = '#1E2140'; ctx.stroke()
      ctx.fillStyle = '#1E2140'
      ctx.fillText(sp.saying, bx + padding, by + bh/2 + 5)
    }

    // Sprite (rocket emoji)
    ctx.save()
    ctx.translate(cx, cy)
    ctx.rotate((sp.angle - 90) * Math.PI / 180)
    ctx.font = `${sz}px serif`
    ctx.textAlign = 'center'
    ctx.textBaseline = 'middle'
    ctx.fillText('🚀', 0, 0)
    ctx.restore()
  }, [])

  useEffect(() => {
    const id = requestAnimationFrame(function loop() {
      drawStage()
      requestAnimationFrame(loop)
    })
    return () => cancelAnimationFrame(id)
  }, [drawStage])

  // ─── Block execution ───────────────────────────────────────────────────────
  const execBlocks = async (blocks: ScriptBlock[]) => {
    for (const block of blocks) {
      if (stopFlag) return
      const def = BLOCK_DEFS.find(d => d.id === block.defId)!
      const inp = block.inputs
      switch (block.defId) {
        case 'move':
          setSprite(s => {
            const rad = (s.angle) * Math.PI / 180
            return { ...s, x: s.x + Math.cos(rad) * +inp.steps, y: s.y + Math.sin(rad) * +inp.steps }
          }); await sleep(50); break
        case 'turn_right':
          setSprite(s => ({ ...s, angle: s.angle + +inp.deg })); await sleep(50); break
        case 'turn_left':
          setSprite(s => ({ ...s, angle: s.angle - +inp.deg })); await sleep(50); break
        case 'goto_xy':
          setSprite(s => ({ ...s, x: +inp.x, y: +inp.y })); await sleep(50); break
        case 'goto_center':
          setSprite(s => ({ ...s, x: 0, y: 0 })); await sleep(50); break
        case 'bounce':
          setSprite(s => {
            const canvas = stageRef.current
            if (!canvas) return s
            const maxX = canvas.width / 2 - 20, maxY = canvas.height / 2 - 20
            let { x, y, angle } = s
            if (Math.abs(x) >= maxX) { angle = 180 - angle; x = Math.sign(x) * maxX }
            if (Math.abs(y) >= maxY) { angle = -angle; y = Math.sign(y) * maxY }
            return { ...s, x, y, angle }
          }); await sleep(50); break
        case 'glide': {
          const steps = 30, delay = (+inp.secs * 1000) / steps
          const start = { x: spriteRef.current.x, y: spriteRef.current.y }
          for (let i = 1; i <= steps; i++) {
            if (stopFlag) return
            const t = i / steps
            setSprite(s => ({ ...s, x: start.x + (Number(inp.x) - start.x) * t, y: start.y + (Number(inp.y) - start.y) * t }))
            await sleep(delay)
          }; break
        }
        case 'say':
          setSprite(s => ({ ...s, saying: String(inp.msg) })); await sleep(1500)
          setSprite(s => ({ ...s, saying: null })); break
        case 'say_secs':
          setSprite(s => ({ ...s, saying: String(inp.msg) })); await sleep(+inp.secs * 1000)
          setSprite(s => ({ ...s, saying: null })); break
        case 'show': setSprite(s => ({ ...s, visible: true })); break
        case 'hide': setSprite(s => ({ ...s, visible: false })); break
        case 'grow': setSpriteSize(sz => Math.min(sz + +inp.amount, 120)); await sleep(50); break
        case 'shrink': setSpriteSize(sz => Math.max(sz - +inp.amount, 10)); await sleep(50); break
        case 'wait': await sleep(+inp.secs * 1000); break
        case 'repeat':
          for (let i = 0; i < +inp.times; i++) {
            if (stopFlag) return
            await execBlocks(block.inputs._children as any || [])
          }; break
        case 'stop': stopFlag = true; return
      }
    }
  }

  const handleRun = async () => {
    if (running) return
    stopFlag = false
    setRunning(true)
    await execBlocks(script)
    setRunning(false)
  }

  const handleStop = () => { stopFlag = true; setRunning(false) }

  const handleReset = () => {
    stopFlag = true; setRunning(false)
    setSprite({ x: 0, y: 0, angle: 0, visible: true, saying: null, sayTimer: null, penDown: false })
    setSpriteSize(40)
  }

  // ─── Drag from palette ─────────────────────────────────────────────────────
  const handlePaletteDragStart = (e: React.DragEvent, defId: string) => {
    e.dataTransfer.setData('blockDefId', defId)
    e.dataTransfer.effectAllowed = 'copy'
  }

  const handleScriptDrop = (e: React.DragEvent) => {
    e.preventDefault()
    setDropHighlight(false)
    const defId = e.dataTransfer.getData('blockDefId')
    if (!defId) return
    const def = BLOCK_DEFS.find(d => d.id === defId)!
    const inputs: Record<string, string | number> = {}
    def.inputs?.forEach(inp => { inputs[inp.id] = inp.default })
    setScript(prev => [...prev, { uid: Math.random().toString(36).slice(2), defId, inputs }])
  }

  const updateInput = (uid: string, inputId: string, value: string | number) => {
    setScript(prev => prev.map(b => b.uid === uid ? { ...b, inputs: { ...b.inputs, [inputId]: value } } : b))
  }

  const removeBlock = (uid: string) => setScript(prev => prev.filter(b => b.uid !== uid))

  const moveBlock = (uid: string, dir: 'up' | 'down') => {
    setScript(prev => {
      const idx = prev.findIndex(b => b.uid === uid)
      if (idx < 0) return prev
      const arr = [...prev]
      const swapIdx = dir === 'up' ? idx - 1 : idx + 1
      if (swapIdx < 0 || swapIdx >= arr.length) return prev
      ;[arr[idx], arr[swapIdx]] = [arr[swapIdx], arr[idx]]
      return arr
    })
  }

  // ─── Render ────────────────────────────────────────────────────────────────
  const categories = Array.from(new Set(BLOCK_DEFS.map(b => b.category)))

  return (
    <div className="flex h-screen overflow-hidden" style={{ fontFamily: 'Nunito, sans-serif', background: '#1E2140' }}>

      {/* ── BLOCK PALETTE ─────────────────────────────────── */}
      <aside className="w-56 flex-shrink-0 overflow-y-auto flex flex-col" style={{ background: '#2B2D42', borderRight: '1px solid #3A3D5C' }}>
        {/* Logo bar */}
        <div className="flex items-center gap-2 px-3 py-3 flex-shrink-0" style={{ borderBottom: '1px solid #3A3D5C' }}>
          <div className="w-7 h-7 rounded-lg flex items-center justify-center" style={{ background: '#F5C518' }}>
            <Rocket size={14} color="#1E2140" />
          </div>
          <div>
            <div className="text-white font-black text-xs leading-none">CODEship</div>
            <div className="font-bold text-xs tracking-widest" style={{ color: '#F5C518', fontSize: 7 }}>BLOCKS</div>
          </div>
        </div>

        {/* Category tabs */}
        <div className="flex flex-wrap gap-1 p-2 flex-shrink-0" style={{ borderBottom: '1px solid #3A3D5C' }}>
          {categories.map(cat => {
            const meta = CAT_META[cat]
            return (
              <button key={cat} onClick={() => setActiveCategory(cat)}
                className="px-2 py-1 rounded-lg text-xs font-bold transition-all"
                style={{ background: activeCategory === cat ? meta.color : 'rgba(255,255,255,0.08)', color: activeCategory === cat ? '#1E2140' : 'rgba(255,255,255,0.5)' }}>
                {meta.emoji}
              </button>
            )
          })}
        </div>

        {/* Blocks */}
        <div className="flex-1 overflow-y-auto p-2 space-y-1.5">
          <div className="text-xs font-black uppercase tracking-widest px-1 mb-2" style={{ color: CAT_META[activeCategory].color }}>
            {CAT_META[activeCategory].emoji} {CAT_META[activeCategory].label}
          </div>
          {BLOCK_DEFS.filter(b => b.category === activeCategory).map(def => (
            <div key={def.id} draggable onDragStart={e => handlePaletteDragStart(e, def.id)}
              className="rounded-xl px-3 py-2 text-xs font-bold cursor-grab active:cursor-grabbing select-none transition-all hover:brightness-110 hover:scale-105"
              style={{ background: def.color, color: 'white', boxShadow: `0 3px 0 ${def.color}88` }}>
              {def.label}
            </div>
          ))}
        </div>
      </aside>

      {/* ── SCRIPT AREA ───────────────────────────────────── */}
      <div className="flex flex-col flex-1 min-w-0 overflow-hidden" style={{ borderRight: '1px solid #3A3D5C' }}>
        {/* Toolbar */}
        <div className="flex items-center gap-2 px-4 py-2.5 flex-shrink-0" style={{ background: '#2B2D42', borderBottom: '1px solid #3A3D5C' }}>
          <span className="text-xs font-black uppercase tracking-widest mr-2" style={{ color: 'rgba(255,255,255,0.4)' }}>My Script</span>
          <button onClick={handleRun} disabled={running || script.length === 0}
            className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-xs font-black transition-all disabled:opacity-40"
            style={{ background: running ? '#22C55E' : '#F5C518', color: '#1E2140' }}>
            <Play size={13} fill="#1E2140" /> {running ? 'Running...' : 'Run'}
          </button>
          <button onClick={handleStop} disabled={!running}
            className="flex items-center gap-1.5 px-3 py-2 rounded-xl text-xs font-black disabled:opacity-40 transition-all"
            style={{ background: '#EF4444', color: 'white' }}>
            <Square size={12} fill="white" /> Stop
          </button>
          <button onClick={handleReset}
            className="flex items-center gap-1.5 px-3 py-2 rounded-xl text-xs font-black transition-all"
            style={{ background: 'rgba(255,255,255,0.1)', color: 'rgba(255,255,255,0.7)' }}>
            <RotateCcw size={12} /> Reset
          </button>
          <div className="ml-auto flex items-center gap-2">
            <button onClick={() => setScript([])}
              className="flex items-center gap-1 px-2.5 py-1.5 rounded-lg text-xs font-bold opacity-50 hover:opacity-100 transition-opacity"
              style={{ background: 'rgba(239,68,68,0.15)', color: '#EF4444' }}>
              <Trash2 size={11} /> Clear
            </button>
            <div className="text-xs font-semibold" style={{ color: 'rgba(255,255,255,0.35)' }}>{script.length} block{script.length !== 1 ? 's' : ''}</div>
          </div>
        </div>

        {/* Drop zone */}
        <div ref={scriptAreaRef}
          className="flex-1 overflow-y-auto p-4"
          style={{ background: dropHighlight ? 'rgba(245,197,24,0.05)' : '#1E2140', transition: 'background 0.15s' }}
          onDragOver={e => { e.preventDefault(); setDropHighlight(true) }}
          onDragLeave={() => setDropHighlight(false)}
          onDrop={handleScriptDrop}>

          {script.length === 0 ? (
            <div className="flex flex-col items-center justify-center h-full gap-4 opacity-30 pointer-events-none">
              <div className="text-5xl">🧩</div>
              <div className="text-center">
                <div className="text-white font-black text-base">Drag blocks here</div>
                <div className="text-xs mt-1" style={{ color: 'rgba(255,255,255,0.5)' }}>Grab from the palette on the left</div>
              </div>
            </div>
          ) : (
            <div className="space-y-1 max-w-xs">
              {script.map((block, idx) => {
                const def = BLOCK_DEFS.find(d => d.id === block.defId)!
                if (!def) return null
                const isHat = def.shape === 'hat'
                return (
                  <div key={block.uid}
                    className="relative group"
                    style={{
                      marginTop: isHat && idx > 0 ? 16 : 0,
                      borderTop: isHat && idx > 0 ? '2px dashed #3A3D5C' : 'none',
                      paddingTop: isHat && idx > 0 ? 16 : 0,
                    }}>
                    {/* Connector notch top */}
                    {!isHat && (
                      <div className="absolute -top-1.5 left-4 w-8 h-3 rounded" style={{ background: def.color }} />
                    )}
                    {/* Block body */}
                    <div className="rounded-xl px-3 py-2.5 flex items-center gap-2 flex-wrap"
                      style={{
                        background: def.color,
                        borderRadius: isHat ? '16px 16px 8px 8px' : '8px',
                        boxShadow: `0 4px 0 ${def.color}99`,
                        paddingTop: isHat ? 12 : undefined,
                      }}>
                      {/* Label with inputs interspersed */}
                      {(() => {
                        const parts = def.label.split('[ ]')
                        return parts.map((part, pi) => (
                          <span key={pi} className="flex items-center gap-1.5">
                            <span className="text-xs font-bold text-white">{part}</span>
                            {pi < (def.inputs?.length ?? 0) && def.inputs?.[pi] && (
                              def.inputs[pi].type === 'select' ? (
                                <select value={block.inputs[def.inputs[pi].id]} onChange={e => updateInput(block.uid, def.inputs![pi].id, e.target.value)}
                                  className="rounded-lg px-2 py-0.5 text-xs font-bold outline-none border-0"
                                  style={{ background: 'rgba(0,0,0,0.25)', color: 'white', minWidth: 60 }}>
                                  {def.inputs[pi].options?.map(o => <option key={o} value={o}>{o}</option>)}
                                </select>
                              ) : (
                                <input type={def.inputs[pi].type === 'number' ? 'number' : 'text'}
                                  value={block.inputs[def.inputs[pi].id]}
                                  onChange={e => updateInput(block.uid, def.inputs![pi].id, def.inputs![pi].type === 'number' ? +e.target.value : e.target.value)}
                                  className="rounded-lg px-2 py-0.5 text-xs font-bold outline-none border-0 text-center"
                                  style={{ background: 'rgba(0,0,0,0.25)', color: 'white', width: def.inputs[pi].type === 'number' ? 52 : 90 }} />
                              )
                            )}
                          </span>
                        ))
                      })()}

                      {/* Block controls */}
                      <div className="ml-auto flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                        <button onClick={() => moveBlock(block.uid, 'up')} disabled={idx === 0}
                          className="w-5 h-5 rounded flex items-center justify-center disabled:opacity-30"
                          style={{ background: 'rgba(0,0,0,0.2)' }}>
                          <ChevronRight size={12} color="white" style={{ transform: 'rotate(-90deg)' }} />
                        </button>
                        <button onClick={() => moveBlock(block.uid, 'down')} disabled={idx === script.length - 1}
                          className="w-5 h-5 rounded flex items-center justify-center disabled:opacity-30"
                          style={{ background: 'rgba(0,0,0,0.2)' }}>
                          <ChevronRight size={12} color="white" style={{ transform: 'rotate(90deg)' }} />
                        </button>
                        <button onClick={() => removeBlock(block.uid)}
                          className="w-5 h-5 rounded flex items-center justify-center"
                          style={{ background: 'rgba(239,68,68,0.4)' }}>
                          <Trash2 size={10} color="white" />
                        </button>
                      </div>
                    </div>

                    {/* Connector notch bottom */}
                    {def.shape !== 'hat' && (
                      <div className="absolute -bottom-1.5 left-4 w-8 h-3 rounded" style={{ background: def.color }} />
                    )}
                  </div>
                )
              })}
              {/* Final connector bottom */}
              {script.length > 0 && script[script.length - 1] && (() => {
                const lastDef = BLOCK_DEFS.find(d => d.id === script[script.length - 1].defId)
                return lastDef?.shape !== 'hat' ? (
                  <div className="h-6 flex items-center pl-4 opacity-30">
                    <div className="w-8 h-3 rounded" style={{ background: '#3A3D5C' }} />
                  </div>
                ) : null
              })()}
            </div>
          )}
        </div>
      </div>

      {/* ── STAGE ─────────────────────────────────────────── */}
      <div className="flex flex-col flex-shrink-0" style={{ width: 440, background: '#2B2D42' }}>
        {/* Stage header */}
        <div className="flex items-center justify-between px-4 py-2.5 flex-shrink-0" style={{ borderBottom: '1px solid #3A3D5C' }}>
          <div className="text-xs font-black text-white uppercase tracking-widest opacity-60">Stage</div>
          <div className="flex items-center gap-3 text-xs" style={{ color: 'rgba(255,255,255,0.4)' }}>
            <span>x: <strong style={{ color: 'rgba(255,255,255,0.7)' }}>{Math.round(sprite.x)}</strong></span>
            <span>y: <strong style={{ color: 'rgba(255,255,255,0.7)' }}>{Math.round(sprite.y)}</strong></span>
            <span>🧭 <strong style={{ color: 'rgba(255,255,255,0.7)' }}>{Math.round(sprite.angle)}°</strong></span>
          </div>
        </div>

        {/* Canvas */}
        <div className="flex items-center justify-center flex-1 p-3">
          <canvas ref={stageRef} width={400} height={300}
            className="rounded-2xl"
            style={{ border: '2px solid #3A3D5C', display: 'block', maxWidth: '100%' }} />
        </div>

        {/* Sprite info */}
        <div className="px-4 py-3 flex-shrink-0" style={{ borderTop: '1px solid #3A3D5C' }}>
          <div className="flex items-center gap-3">
            <div className="text-3xl">🚀</div>
            <div>
              <div className="text-xs font-black text-white">Rocket Sprite</div>
              <div className="flex items-center gap-3 mt-0.5 text-xs" style={{ color: 'rgba(255,255,255,0.4)' }}>
                <span>Size: {Math.round(spriteSize)}px</span>
                <span>{sprite.visible ? '👁️ Visible' : '🙈 Hidden'}</span>
              </div>
            </div>

            {/* Quick start button */}
            {script.length === 0 && (
              <button onClick={() => setScript([
                { uid: 'demo1', defId: 'when_flag', inputs: {} },
                { uid: 'demo2', defId: 'say_secs', inputs: { msg: 'Hello! 🚀', secs: 2 } },
                { uid: 'demo3', defId: 'repeat', inputs: { times: 4 } },
                { uid: 'demo4', defId: 'move', inputs: { steps: 60 } },
                { uid: 'demo5', defId: 'turn_right', inputs: { deg: 90 } },
                { uid: 'demo6', defId: 'say', inputs: { msg: 'Done! ✓' } },
              ])}
                className="ml-auto text-xs font-bold px-3 py-1.5 rounded-xl"
                style={{ background: '#F5C51820', color: '#F5C518', border: '1px solid #F5C51840' }}>
                ✨ Try example
              </button>
            )}
          </div>

          <div className="mt-3 text-xs rounded-xl px-3 py-2" style={{ background: 'rgba(245,197,24,0.08)', color: 'rgba(255,255,255,0.45)' }}>
            💡 Drag blocks from the left → click <strong style={{ color: '#F5C518' }}>Run</strong> to see your rocket move!
          </div>
        </div>
      </div>
    </div>
  )
}
