import { useState } from 'react'

export default function AIAssistantModal({ isOpen, onClose }: { isOpen: boolean; onClose: () => void }) {
  const [tab, setTab] = useState<'tutor' | 'quiz' | 'summarizer'>('tutor')
  const [messages, setMessages] = useState<Array<{ sender: 'ai' | 'user'; text: string }>>([
    { sender: 'ai', text: 'Hello! I am your AI Learning Assistant. Ask me anything about your current courses, request homework help, or summarize lecture notes!' }
  ])
  const [input, setInput] = useState('')
  const [lessonText, setLessonText] = useState('')
  const [generatedQuiz, setGeneratedQuiz] = useState<Array<{ q: string; options: string[]; answer: string }> | null>(null)
  const [summaryResult, setSummaryResult] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  if (!isOpen) return null

  const handleSendMessage = () => {
    if (!input.trim()) return
    const userMsg = input
    setMessages(prev => [...prev, { sender: 'user', text: userMsg }])
    setInput('')
    setLoading(true)

    setTimeout(() => {
      setMessages(prev => [
        ...prev,
        {
          sender: 'ai',
          text: `Great question regarding "${userMsg}"! In Differential Equations, integration by parts applies when integrating the product of two functions. Let me know if you want step-by-step flashcards or practice questions!`
        }
      ])
      setLoading(false)
    }, 1000)
  }

  const handleGenerateQuiz = () => {
    setLoading(true)
    setTimeout(() => {
      setGeneratedQuiz([
        {
          q: '1. What is the general solution of dy/dx = y?',
          options: ['y = C * e^x', 'y = C * x', 'y = e^(-x)', 'y = C * ln(x)'],
          answer: 'y = C * e^x'
        },
        {
          q: '2. Which method is best for solving second-order linear differential equations with constant coefficients?',
          options: ['Characteristic Equation Method', 'Integration by Parts', 'Simpson Rule', 'Euler Method'],
          answer: 'Characteristic Equation Method'
        }
      ])
      setLoading(false)
    }, 1200)
  }

  const handleSummarize = () => {
    setLoading(true)
    setTimeout(() => {
      setSummaryResult(
        '📌 **Lecture Summary: Differential Equations & Applications**\n\n' +
        '1. **Key Concept**: First-order separable equations can be solved by grouping terms with $y$ on one side and $x$ on the other.\n' +
        '2. **Boundary Conditions**: Used to compute the specific constant $C$ from general solutions.\n' +
        '3. **Action Item**: Complete Problem Set 7 due tonight at 11:59 PM.'
      )
      setLoading(false)
    }, 1000)
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4" style={{ background: 'rgba(0, 0, 0, 0.75)', backdropFilter: 'blur(8px)' }}>
      <div
        className="w-full max-w-2xl rounded-2xl border flex flex-col overflow-hidden shadow-2xl transition-all"
        style={{ background: 'var(--card)', borderColor: 'var(--border)', maxHeight: '85vh' }}
      >
        {/* Modal Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b" style={{ borderColor: 'var(--border)' }}>
          <div className="flex items-center gap-2">
            <span className="text-xl">✨</span>
            <div>
              <h3 className="font-semibold text-base" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
                LearnSpace AI Suite (Future-Ready Engine)
              </h3>
              <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>Context-Aware AI Tutor, Automated Quiz Generator & Summarizer</p>
            </div>
          </div>
          <button onClick={onClose} className="text-slate-400 hover:text-white text-lg font-bold">✕</button>
        </div>

        {/* Navigation Tabs */}
        <div className="flex border-b text-xs font-medium" style={{ borderColor: 'var(--border)' }}>
          {[
            { id: 'tutor', label: '💬 AI Tutor Bot' },
            { id: 'quiz', label: '⚡ Auto Quiz Generator' },
            { id: 'summarizer', label: '📝 Lesson Summarizer' },
          ].map(t => (
            <button
              key={t.id}
              onClick={() => setTab(t.id as any)}
              className="flex-1 py-3 transition-colors border-b-2"
              style={{
                color: tab === t.id ? 'var(--primary)' : 'var(--muted-foreground)',
                borderColor: tab === t.id ? 'var(--primary)' : 'transparent',
              }}
            >
              {t.label}
            </button>
          ))}
        </div>

        {/* Modal Body */}
        <div className="flex-1 overflow-y-auto p-6 flex flex-col gap-4" style={{ minHeight: 320 }}>
          {tab === 'tutor' && (
            <div className="flex flex-col gap-3 flex-1 justify-between">
              <div className="flex flex-col gap-3 max-h-72 overflow-y-auto pr-1">
                {messages.map((m, i) => (
                  <div key={i} className={`flex gap-3 ${m.sender === 'user' ? 'justify-end' : 'justify-start'}`}>
                    {m.sender === 'ai' && (
                      <div className="w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold shrink-0" style={{ background: 'var(--primary)33', color: 'var(--primary)' }}>
                        AI
                      </div>
                    )}
                    <div
                      className="p-3 rounded-xl text-xs leading-relaxed max-w-[85%]"
                      style={{
                        background: m.sender === 'user' ? 'var(--primary)' : 'var(--muted)',
                        color: m.sender === 'user' ? '#fff' : 'var(--foreground)',
                      }}
                    >
                      {m.text}
                    </div>
                  </div>
                ))}
                {loading && (
                  <p className="text-xs mono text-slate-400 animate-pulse">AI is thinking...</p>
                )}
              </div>
              <div className="flex gap-2 pt-2 border-t" style={{ borderColor: 'var(--border)' }}>
                <input
                  type="text"
                  value={input}
                  onChange={e => setInput(e.target.value)}
                  onKeyDown={e => e.key === 'Enter' && handleSendMessage()}
                  placeholder="Ask AI Tutor a question about your lessons..."
                  className="flex-1 px-4 py-2.5 rounded-xl text-xs border outline-none"
                  style={{ background: 'var(--muted)', borderColor: 'var(--border)', color: 'var(--foreground)' }}
                />
                <button
                  onClick={handleSendMessage}
                  className="px-5 py-2.5 rounded-xl text-xs font-semibold"
                  style={{ background: 'var(--primary)', color: '#fff' }}
                >
                  Send
                </button>
              </div>
            </div>
          )}

          {tab === 'quiz' && (
            <div className="flex flex-col gap-4">
              <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>
                Upload or paste your raw lecture text below, and AI will generate custom multiple-choice quizzes automatically.
              </p>
              <textarea
                rows={3}
                placeholder="Paste lesson transcript or text here..."
                value={lessonText}
                onChange={e => setLessonText(e.target.value)}
                className="w-full p-3 rounded-xl text-xs border outline-none font-mono"
                style={{ background: 'var(--muted)', borderColor: 'var(--border)', color: 'var(--foreground)' }}
              />
              <button
                onClick={handleGenerateQuiz}
                disabled={loading}
                className="px-4 py-2.5 rounded-xl text-xs font-semibold self-start"
                style={{ background: 'var(--accent)', color: 'var(--accent-foreground)' }}
              >
                {loading ? 'Generating Quiz...' : '✨ Generate 2-Question Sample Quiz'}
              </button>

              {generatedQuiz && (
                <div className="flex flex-col gap-3 mt-2 border-t pt-4" style={{ borderColor: 'var(--border)' }}>
                  <h4 className="text-xs font-bold uppercase tracking-wider text-slate-300">Generated Quiz Result</h4>
                  {generatedQuiz.map((item, idx) => (
                    <div key={idx} className="p-3 rounded-xl border text-xs" style={{ background: 'var(--muted)', borderColor: 'var(--border)' }}>
                      <p className="font-semibold mb-2">{item.q}</p>
                      <div className="grid grid-cols-2 gap-2">
                        {item.options.map(opt => (
                          <div
                            key={opt}
                            className="p-2 rounded border text-slate-300 font-mono"
                            style={{
                              borderColor: opt === item.answer ? 'var(--accent)' : 'var(--border)',
                              background: opt === item.answer ? 'var(--accent)15' : 'transparent',
                            }}
                          >
                            {opt} {opt === item.answer && '✓'}
                          </div>
                        ))}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {tab === 'summarizer' && (
            <div className="flex flex-col gap-4">
              <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>
                AI Speech-to-Text & Lesson Summarizer extracts core topics and key takeaways from live stream recordings.
              </p>
              <button
                onClick={handleSummarize}
                disabled={loading}
                className="px-4 py-2.5 rounded-xl text-xs font-semibold self-start"
                style={{ background: 'var(--primary)', color: '#fff' }}
              >
                {loading ? 'Summarizing...' : '⚡ Summarize Recent MATH 401 Session'}
              </button>

              {summaryResult && (
                <div className="p-4 rounded-xl border text-xs leading-relaxed whitespace-pre-line" style={{ background: 'var(--muted)', borderColor: 'var(--border)' }}>
                  {summaryResult}
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
