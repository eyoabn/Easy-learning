import { useState } from 'react'
import type { AuthUser } from './AuthFlow'

interface AdminPortalProps {
  pendingUsers: AuthUser[]
  onApprove: (id: string) => void
  onReject: (id: string) => void
  onLogout: () => void
  currentUser: AuthUser
}

const systemStats = [
  { label: 'Schools & Institutes', value: '14', sub: '3 Pending setup', icon: '🏛️', color: '#a78bfa' },
  { label: 'Active Teachers', value: '428', sub: 'Across all departments', icon: '📚', color: '#4c7eff' },
  { label: 'Enrolled Students', value: '18,520', sub: '99.4% Active', icon: '🎓', color: '#00d9a3' },
  { label: 'Live Streams', value: '38', sub: '1,420 viewers now', icon: '📡', color: '#fb923c' },
]

const schools = [
  { id: 'SCH-01', name: 'School of Engineering & Technology', depts: 6, teachers: 142, students: 6400, dean: 'Dr. Marcus Vance', status: 'active' },
  { id: 'SCH-02', name: 'School of Health & Life Sciences', depts: 4, teachers: 98, students: 4200, dean: 'Prof. Helen Shaw', status: 'active' },
  { id: 'SCH-03', name: 'School of Business & Economics', depts: 5, teachers: 110, students: 5100, dean: 'Dr. Aris Thorne', status: 'active' },
  { id: 'SCH-04', name: 'Faculty of Arts & Humanities', depts: 7, teachers: 78, students: 2820, dean: 'Dr. Sadiya Khan', status: 'active' },
]

const auditLogs = [
  { id: 'LOG-8841', timestamp: '2026-07-24 14:10', actor: 'Admin', action: 'USER_APPROVED', target: 'Dr. Vasquez → Teacher', ip: '192.168.1.45' },
  { id: 'LOG-8840', timestamp: '2026-07-24 13:58', actor: 'System', action: 'ROOM_RECORDED', target: 'MATH 401 Session #44', ip: '10.0.4.12' },
  { id: 'LOG-8839', timestamp: '2026-07-24 12:40', actor: 'Admin', action: 'QUOTA_RESIZED', target: 'Engineering Bucket → 5TB', ip: '192.168.1.45' },
  { id: 'LOG-8838', timestamp: '2026-07-24 11:15', actor: 'Teacher', action: 'QUIZ_PUBLISHED', target: 'MATH401 Midterm Quiz', ip: '172.16.0.88' },
  { id: 'LOG-8837', timestamp: '2026-07-24 10:03', actor: 'Admin', action: 'USER_REJECTED', target: 'Spam account attempt', ip: '45.22.188.9' },
]

const liveSessions = [
  { name: 'MATH 401 — Differential Eq', host: 'Dr. Vasquez', students: 38, room: 'livekit-room-401' },
  { name: 'BIO 310 — CRISPR Workshop', host: 'Prof. Okonkwo', students: 55, room: 'livekit-room-310' },
  { name: 'CS 301 — Graph Theory', host: 'Dr. Lee', students: 42, room: 'livekit-room-301' },
]

type Tab = 'overview' | 'approvals' | 'institutions' | 'users' | 'audit'

export default function AdminPortal({ pendingUsers, onApprove, onReject, onLogout, currentUser }: AdminPortalProps) {
  const [activeTab, setActiveTab] = useState<Tab>('overview')
  const [toast, setToast] = useState<{ msg: string; type: 'success' | 'error' } | null>(null)

  const showToast = (msg: string, type: 'success' | 'error' = 'success') => {
    setToast({ msg, type })
    setTimeout(() => setToast(null), 3000)
  }

  const handleApprove = (user: AuthUser) => {
    onApprove(user.id)
    showToast(`✓ Approved ${user.name} as ${user.role}`)
  }

  const handleReject = (user: AuthUser) => {
    onReject(user.id)
    showToast(`Rejected ${user.name}'s application`, 'error')
  }

  const tabs: { id: Tab; label: string; icon: string }[] = [
    { id: 'overview', label: 'Overview', icon: '📊' },
    { id: 'approvals', label: `Approvals${pendingUsers.length > 0 ? ` (${pendingUsers.length})` : ''}`, icon: '✅' },
    { id: 'institutions', label: 'Institutions', icon: '🏛️' },
    { id: 'audit', label: 'Audit Logs', icon: '🔍' },
  ]

  return (
    <div className="flex flex-col gap-6 px-8 py-8 max-w-7xl mx-auto w-full relative">
      {/* Toast */}
      {toast && (
        <div
          className="fixed bottom-6 right-6 z-50 px-5 py-3 rounded-2xl shadow-2xl border text-sm font-medium flex items-center gap-2"
          style={{
            background: 'var(--card)',
            borderColor: toast.type === 'success' ? 'var(--accent)' : '#ef4444',
            color: toast.type === 'success' ? 'var(--accent)' : '#ef4444',
          }}
        >
          <span className="w-2 h-2 rounded-full" style={{ background: 'currentColor' }} />
          {toast.msg}
        </div>
      )}

      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <p className="mono text-xs tracking-widest uppercase mb-1.5" style={{ color: 'var(--accent)' }}>
            System Administrator
          </p>
          <h1 className="text-3xl font-semibold tracking-tight" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
            Admin Control Center
          </h1>
          <p className="text-sm mt-1" style={{ color: 'var(--muted-foreground)' }}>
            Welcome back, <strong style={{ color: 'var(--foreground)' }}>{currentUser.name}</strong> · Manage users, institutions, and system operations.
          </p>
        </div>
        <button
          onClick={onLogout}
          className="flex items-center gap-2 px-4 py-2 rounded-xl border text-xs font-medium transition-colors hover:bg-white/[0.04]"
          style={{ borderColor: 'var(--border)', color: 'var(--muted-foreground)' }}
        >
          ← Sign Out
        </button>
      </div>

      {/* Tab nav */}
      <div className="flex gap-1 p-1 rounded-xl w-fit" style={{ background: 'var(--muted)' }}>
        {tabs.map(tab => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className="flex items-center gap-2 px-4 py-2 rounded-lg text-xs font-medium transition-all"
            style={{
              background: activeTab === tab.id ? 'var(--card)' : 'transparent',
              color: activeTab === tab.id ? 'var(--foreground)' : 'var(--muted-foreground)',
              fontFamily: 'Lexend',
              boxShadow: activeTab === tab.id ? '0 1px 3px rgba(0,0,0,0.3)' : 'none',
            }}
          >
            <span>{tab.icon}</span>
            <span>{tab.label}</span>
            {tab.id === 'approvals' && pendingUsers.length > 0 && (
              <span className="w-1.5 h-1.5 rounded-full" style={{ background: '#fb923c' }} />
            )}
          </button>
        ))}
      </div>

      {/* ── OVERVIEW TAB ── */}
      {activeTab === 'overview' && (
        <>
          <div className="grid grid-cols-4 gap-4">
            {systemStats.map(s => (
              <div key={s.label} className="rounded-2xl p-5 border flex flex-col gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <div className="flex items-center justify-between">
                  <p className="text-xs mono uppercase tracking-widest" style={{ color: 'var(--muted-foreground)' }}>{s.label}</p>
                  <span className="w-8 h-8 rounded-xl flex items-center justify-center text-base" style={{ background: s.color + '22' }}>{s.icon}</span>
                </div>
                <p className="text-2xl font-semibold" style={{ fontFamily: 'Lexend', color: s.color }}>{s.value}</p>
                <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>{s.sub}</p>
              </div>
            ))}
          </div>

          <div className="grid grid-cols-3 gap-5">
            {/* Infrastructure health */}
            <div className="col-span-2 rounded-2xl border p-6 flex flex-col gap-5" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-sm font-semibold" style={{ fontFamily: 'Lexend' }}>Infrastructure Health</h3>
                  <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>LiveKit SFU, PostgreSQL cluster, S3 storage</p>
                </div>
                <span className="mono text-xs px-3 py-1 rounded-full font-medium" style={{ background: 'var(--accent)22', color: 'var(--accent)', border: '1px solid var(--accent)44' }}>
                  ● All Systems Operational
                </span>
              </div>

              <div className="grid grid-cols-3 gap-4">
                {[
                  { label: 'PostgreSQL Nodes', value: 'Primary + 2 Replicas', detail: 'Lat: 1.2ms · 99.99% uptime', color: 'var(--accent)' },
                  { label: 'LiveKit SFU', value: '4 Nodes Active', detail: '3.4 Gbps Bandwidth', color: 'var(--primary)' },
                  { label: 'S3 Storage', value: '18.4 TB / 50 TB', detail: '37% used · Auto-egress on', color: '#fb923c' },
                ].map(item => (
                  <div key={item.label} className="p-4 rounded-xl border" style={{ background: 'var(--muted)', borderColor: 'var(--border)' }}>
                    <p className="text-xs mono uppercase text-slate-400">{item.label}</p>
                    <p className="text-sm font-semibold mt-1.5" style={{ fontFamily: 'Lexend' }}>{item.value}</p>
                    <p className="text-xs mt-1" style={{ color: item.color }}>{item.detail}</p>
                  </div>
                ))}
              </div>

              <div>
                <h4 className="text-xs mono uppercase tracking-widest mb-3" style={{ color: 'var(--muted-foreground)' }}>Quick Admin Actions</h4>
                <div className="flex flex-wrap gap-2">
                  {[
                    { label: '💾 DB Backup', action: 'Triggered database backup snapshot...' },
                    { label: '⚡ Flush RBAC Cache', action: 'Flushed Redis permission cache' },
                    { label: '📄 Export Audit PDF', action: 'Exporting system audit log as PDF...' },
                    { label: '🔄 Sync Directory', action: 'Syncing LDAP/AD directory...' },
                  ].map(btn => (
                    <button
                      key={btn.label}
                      onClick={() => showToast(btn.action)}
                      className="px-4 py-2 rounded-xl text-xs font-medium border transition-colors hover:bg-white/[0.04]"
                      style={{ borderColor: 'var(--border)', color: 'var(--foreground)' }}
                    >
                      {btn.label}
                    </button>
                  ))}
                </div>
              </div>
            </div>

            {/* Live sessions */}
            <div className="rounded-2xl border p-5 flex flex-col gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
              <div className="flex items-center justify-between">
                <h3 className="text-sm font-semibold" style={{ fontFamily: 'Lexend' }}>Active Live Sessions</h3>
                <span className="w-2 h-2 rounded-full animate-pulse" style={{ background: 'var(--accent)' }} />
              </div>
              <div className="flex flex-col gap-2">
                {liveSessions.map((room, i) => (
                  <div key={i} className="p-3 rounded-xl border" style={{ background: 'var(--muted)', borderColor: 'var(--border)' }}>
                    <div className="flex items-center justify-between mb-1">
                      <p className="text-xs font-medium leading-tight">{room.name}</p>
                      <span className="mono text-xs px-2 py-0.5 rounded-full" style={{ background: 'var(--accent)22', color: 'var(--accent)' }}>
                        {room.students}
                      </span>
                    </div>
                    <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>Host: {room.host}</p>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </>
      )}

      {/* ── APPROVALS TAB ── */}
      {activeTab === 'approvals' && (
        <div className="flex flex-col gap-4">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-base font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
                User Registration Approvals
              </h2>
              <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>
                Review and approve teacher & student registrations
              </p>
            </div>
            {pendingUsers.length > 0 && (
              <span className="mono text-xs px-3 py-1 rounded-full font-medium" style={{ background: '#fb923c22', color: '#fb923c', border: '1px solid #fb923c44' }}>
                {pendingUsers.length} pending
              </span>
            )}
          </div>

          {pendingUsers.length === 0 ? (
            <div className="rounded-2xl border p-12 flex flex-col items-center gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
              <div className="text-4xl">✅</div>
              <p className="text-sm font-medium" style={{ fontFamily: 'Lexend' }}>All clear!</p>
              <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>
                No pending registration requests at this time.
              </p>
            </div>
          ) : (
            <div className="flex flex-col gap-3">
              {pendingUsers.map(user => (
                <div
                  key={user.id}
                  className="rounded-2xl border p-5 flex items-center gap-5"
                  style={{ background: 'var(--card)', borderColor: 'var(--border)' }}
                >
                  {/* Avatar */}
                  <div
                    className="w-12 h-12 rounded-xl flex items-center justify-center text-sm font-bold shrink-0"
                    style={{
                      background: user.role === 'teacher' ? '#4c7eff22' : '#00d9a322',
                      color: user.role === 'teacher' ? '#4c7eff' : '#00d9a3',
                      fontFamily: 'Lexend',
                    }}
                  >
                    {user.avatar}
                  </div>

                  {/* Info */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-0.5">
                      <p className="font-semibold text-sm" style={{ fontFamily: 'Lexend' }}>{user.name}</p>
                      <span
                        className="mono text-xs px-2 py-0.5 rounded-full capitalize"
                        style={{
                          background: user.role === 'teacher' ? '#4c7eff22' : '#00d9a322',
                          color: user.role === 'teacher' ? '#4c7eff' : '#00d9a3',
                        }}
                      >
                        {user.role}
                      </span>
                    </div>
                    <p className="text-xs mono" style={{ color: 'var(--muted-foreground)' }}>{user.email}</p>
                    <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>
                      Department: {user.department || 'Not specified'}
                    </p>
                  </div>

                  {/* Status */}
                  <span className="mono text-xs px-3 py-1 rounded-full" style={{ background: '#fb923c22', color: '#fb923c', border: '1px solid #fb923c33' }}>
                    Pending Review
                  </span>

                  {/* Actions */}
                  <div className="flex items-center gap-2 shrink-0">
                    <button
                      onClick={() => handleApprove(user)}
                      className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-xs font-semibold transition-opacity hover:opacity-80"
                      style={{ background: 'var(--accent)', color: 'var(--accent-foreground)' }}
                    >
                      ✓ Approve
                    </button>
                    <button
                      onClick={() => handleReject(user)}
                      className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-xs font-semibold border transition-opacity hover:opacity-80"
                      style={{ borderColor: '#ef444466', color: '#ef4444', background: '#ef444411' }}
                    >
                      ✕ Reject
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}

      {/* ── INSTITUTIONS TAB ── */}
      {activeTab === 'institutions' && (
        <div className="flex flex-col gap-4">
          <div className="flex justify-between items-center">
            <div>
              <h2 className="text-base font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
                Schools & Faculty Units
              </h2>
              <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>
                Manage institutional hierarchy and department structure
              </p>
            </div>
            <button
              onClick={() => showToast('Opening New School setup wizard...')}
              className="flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-semibold"
              style={{ background: 'var(--primary)', color: '#fff' }}
            >
              + Add New School
            </button>
          </div>

          <div className="grid grid-cols-2 gap-4">
            {schools.map(sch => (
              <div key={sch.id} className="rounded-2xl border p-5 flex flex-col gap-4" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <div className="flex justify-between items-start">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <span className="mono text-xs" style={{ color: 'var(--primary)' }}>{sch.id}</span>
                      <span className="mono text-xs px-2 py-0.5 rounded-full" style={{ background: 'var(--accent)22', color: 'var(--accent)' }}>Active</span>
                    </div>
                    <h3 className="font-semibold text-sm leading-snug" style={{ fontFamily: 'Lexend' }}>{sch.name}</h3>
                    <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>Dean: {sch.dean}</p>
                  </div>
                  <button
                    onClick={() => showToast(`Managing ${sch.name}...`)}
                    className="text-xs px-3 py-1 rounded-lg border transition-colors hover:bg-white/[0.04] shrink-0 ml-2"
                    style={{ borderColor: 'var(--border)', color: 'var(--muted-foreground)' }}
                  >
                    Manage
                  </button>
                </div>
                <div className="grid grid-cols-3 gap-3 pt-3 border-t text-center" style={{ borderColor: 'var(--border)' }}>
                  {[
                    { label: 'Departments', value: sch.depts },
                    { label: 'Teachers', value: sch.teachers },
                    { label: 'Students', value: sch.students.toLocaleString() },
                  ].map(s => (
                    <div key={s.label}>
                      <p className="mono text-xs text-slate-400">{s.label}</p>
                      <p className="font-semibold text-sm mt-0.5">{s.value}</p>
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* ── AUDIT TAB ── */}
      {activeTab === 'audit' && (
        <div className="flex flex-col gap-4">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-base font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
                Security & Compliance Audit Trail
              </h2>
              <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>
                Immutable log of all system events
              </p>
            </div>
            <button
              onClick={() => showToast('Exporting audit logs as PDF...')}
              className="text-xs px-4 py-2 rounded-xl border font-medium transition-colors hover:bg-white/[0.04]"
              style={{ borderColor: 'var(--border)', color: 'var(--muted-foreground)' }}
            >
              📄 Export PDF
            </button>
          </div>

          <div className="rounded-2xl border overflow-hidden" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
            <table className="w-full text-sm">
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border)', background: 'var(--muted)' }}>
                  {['Log ID', 'Timestamp', 'Actor', 'Action', 'Target / Details', 'IP'].map(h => (
                    <th key={h} className="text-left px-5 py-3 text-xs mono uppercase tracking-widest font-medium" style={{ color: 'var(--muted-foreground)' }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {auditLogs.map((log, i) => (
                  <tr key={log.id} className="transition-colors hover:bg-white/[0.02]" style={{ borderTop: i > 0 ? '1px solid var(--border)' : undefined }}>
                    <td className="px-5 py-3 mono text-xs font-bold" style={{ color: 'var(--primary)' }}>{log.id}</td>
                    <td className="px-5 py-3 mono text-xs" style={{ color: 'var(--muted-foreground)' }}>{log.timestamp}</td>
                    <td className="px-5 py-3 text-xs font-medium">{log.actor}</td>
                    <td className="px-5 py-3">
                      <span className="mono text-xs px-2 py-0.5 rounded-md" style={{ background: 'var(--muted)', color: 'var(--foreground)' }}>
                        {log.action}
                      </span>
                    </td>
                    <td className="px-5 py-3 text-xs" style={{ color: 'var(--muted-foreground)' }}>{log.target}</td>
                    <td className="px-5 py-3 mono text-xs" style={{ color: 'var(--muted-foreground)' }}>{log.ip}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  )
}
