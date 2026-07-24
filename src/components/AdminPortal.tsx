import { useState } from 'react'

const systemStats = [
  { label: 'Schools & Institutes', value: '14', sub: '3 Pending setup' },
  { label: 'Active Teachers', value: '428', sub: '12 Approvals pending' },
  { label: 'Enrolled Students', value: '18,520', sub: '99.4% Active' },
  { label: 'LiveKit Streams', value: '38 Active', sub: '1,420 Viewers' },
]

const schools = [
  { id: 'SCH-01', name: 'School of Engineering & Technology', depts: 6, teachers: 142, students: 6400, dean: 'Dr. Marcus Vance', status: 'active' },
  { id: 'SCH-02', name: 'School of Health & Life Sciences', depts: 4, teachers: 98, students: 4200, dean: 'Prof. Helen Shaw', status: 'active' },
  { id: 'SCH-03', name: 'School of Business & Economics', depts: 5, teachers: 110, students: 5100, dean: 'Dr. Aris Thorne', status: 'active' },
  { id: 'SCH-04', name: 'Faculty of Arts & Humanities', depts: 7, teachers: 78, students: 2820, dean: 'Dr. Sadiya Khan', status: 'active' },
]

const pendingApprovals = [
  { id: 'REQ-101', name: 'Dr. Julian Thorne', email: 'j.thorne@mit.edu', role: 'Teacher', dept: 'Computer Science', date: 'Jul 24, 2026', status: 'Pending Review' },
  { id: 'REQ-102', name: 'Dr. Amrita Roy', email: 'a.roy@oxford.edu', role: 'Teacher', dept: 'Bio-Physics', date: 'Jul 24, 2026', status: 'Pending Review' },
  { id: 'REQ-103', name: 'Lucas Meyer', email: 'l.meyer@student.edu', role: 'Student', dept: 'Mechanical Eng', date: 'Jul 23, 2026', status: 'Pending Review' },
]

const auditLogs = [
  { id: 'LOG-8841', timestamp: '2026-07-24 14:10:02', actor: 'Admin (Amara D.)', action: 'USER_ROLE_UPDATE', target: 'Dr. Vasquez -> Lead Instructor', ip: '192.168.1.45' },
  { id: 'LOG-8840', timestamp: '2026-07-24 13:58:22', actor: 'System (LiveKit)', action: 'ROOM_EGRESS_RECORDED', target: 'MATH 401 Session #44', ip: '10.0.4.12' },
  { id: 'LOG-8839', timestamp: '2026-07-24 12:40:11', actor: 'Admin (Amara D.)', action: 'S3_STORAGE_QUOTA_RESIZED', target: 'Engineering Bucket -> 5TB', ip: '192.168.1.45' },
  { id: 'LOG-8838', timestamp: '2026-07-24 11:15:49', actor: 'Teacher (Dr. Vasquez)', action: 'QUIZ_PUBLISHED', target: 'MATH401 Midterm Quiz', ip: '172.16.0.88' },
]

export default function AdminPortal() {
  const [activeTab, setActiveTab] = useState<'overview' | 'approvals' | 'institutions' | 'audit'>('overview')
  const [approvalsList, setApprovalsList] = useState(pendingApprovals)
  const [toast, setToast] = useState<string | null>(null)

  const showNotification = (msg: string) => {
    setToast(msg)
    setTimeout(() => setToast(null), 3000)
  }

  const handleApprove = (id: string, name: string) => {
    setApprovalsList(prev => prev.filter(item => item.id !== id))
    showNotification(`Approved ${name} successfully!`)
  }

  const handleReject = (id: string, name: string) => {
    setApprovalsList(prev => prev.filter(item => item.id !== id))
    showNotification(`Rejected application for ${name}.`)
  }

  return (
    <div className="flex flex-col gap-8 px-8 py-8 max-w-7xl mx-auto w-full relative">
      {/* Toast Notification */}
      {toast && (
        <div
          className="fixed bottom-6 right-6 z-50 px-4 py-3 rounded-xl shadow-lg border text-xs font-semibold flex items-center gap-2 animate-bounce"
          style={{ background: 'var(--card)', borderColor: 'var(--primary)', color: 'var(--foreground)' }}
        >
          <span className="w-2 h-2 rounded-full" style={{ background: 'var(--accent)' }} />
          {toast}
        </div>
      )}

      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <p className="mono text-xs tracking-widest uppercase mb-1" style={{ color: 'var(--accent)' }}>
            System Administrator — Control Center
          </p>
          <h1 className="text-3xl font-semibold tracking-tight" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
            Institutional Governance & Ops
          </h1>
          <p className="text-sm mt-1" style={{ color: 'var(--muted-foreground)' }}>
            Global tenant configuration, RBAC permissions, LiveKit server metrics & audit logs.
          </p>
        </div>
        <div className="flex gap-2 mt-1">
          {(['overview', 'approvals', 'institutions', 'audit'] as const).map(tab => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className="px-4 py-2 rounded-full text-sm font-medium capitalize transition-all"
              style={{
                background: activeTab === tab ? 'var(--primary)' : 'var(--secondary)',
                color: activeTab === tab ? '#fff' : 'var(--muted-foreground)',
              }}
            >
              {tab === 'approvals' ? `Approvals (${approvalsList.length})` : tab}
            </button>
          ))}
        </div>
      </div>

      {activeTab === 'overview' && (
        <>
          {/* Stats Grid */}
          <div className="grid grid-cols-4 gap-4">
            {systemStats.map(s => (
              <div key={s.label} className="rounded-xl p-5 border" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <p className="text-xs mono uppercase tracking-widest mb-2" style={{ color: 'var(--muted-foreground)' }}>{s.label}</p>
                <p className="text-2xl font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>{s.value}</p>
                <p className="text-xs mt-1" style={{ color: 'var(--muted-foreground)' }}>{s.sub}</p>
              </div>
            ))}
          </div>

          {/* Core System Infrastructure Panel */}
          <div className="grid grid-cols-3 gap-6">
            <div className="col-span-2 rounded-xl border p-6 flex flex-col gap-6" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-sm font-semibold" style={{ fontFamily: 'Lexend' }}>LiveKit Media Engine & Infrastructure Health</h3>
                  <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>Self-hosted WebRTC SFU, PostgreSQL cluster, S3 Object Storage</p>
                </div>
                <span className="mono text-xs px-2.5 py-1 rounded-full font-medium" style={{ background: 'var(--accent)22', color: 'var(--accent)', border: '1px solid var(--accent)44' }}>
                  ● All Systems Operational
                </span>
              </div>

              <div className="grid grid-cols-3 gap-4">
                <div className="p-4 rounded-xl border" style={{ background: 'var(--muted)', borderColor: 'var(--border)' }}>
                  <p className="text-xs mono uppercase text-slate-400">PostgreSQL Nodes</p>
                  <p className="text-lg font-semibold mt-1" style={{ fontFamily: 'Lexend' }}>Primary + 2 Replicas</p>
                  <p className="text-xs mt-1" style={{ color: 'var(--accent)' }}>Lat: 1.2ms · 99.99% Uptime</p>
                </div>
                <div className="p-4 rounded-xl border" style={{ background: 'var(--muted)', borderColor: 'var(--border)' }}>
                  <p className="text-xs mono uppercase text-slate-400">LiveKit WebRTC SFU</p>
                  <p className="text-lg font-semibold mt-1" style={{ fontFamily: 'Lexend' }}>4 Nodes Active</p>
                  <p className="text-xs mt-1" style={{ color: 'var(--primary)' }}>3.4 Gbps Bandwidth</p>
                </div>
                <div className="p-4 rounded-xl border" style={{ background: 'var(--muted)', borderColor: 'var(--border)' }}>
                  <p className="text-xs mono uppercase text-slate-400">MinIO / AWS S3</p>
                  <p className="text-lg font-semibold mt-1" style={{ fontFamily: 'Lexend' }}>18.4 TB / 50 TB</p>
                  <p className="text-xs mt-1" style={{ color: '#fb923c' }}>Auto-Egress Egress Active</p>
                </div>
              </div>

              {/* Quick Actions */}
              <div>
                <h4 className="text-xs mono uppercase tracking-widest mb-3" style={{ color: 'var(--muted-foreground)' }}>Admin Actions</h4>
                <div className="flex gap-3">
                  <button
                    onClick={() => showNotification('Triggered Database Backup snapshot...')}
                    className="px-4 py-2 rounded-lg text-xs font-medium border transition-colors hover:bg-white/[0.04]"
                    style={{ borderColor: 'var(--border)', color: 'var(--foreground)' }}
                  >
                    💾 Trigger DB Backup
                  </button>
                  <button
                    onClick={() => showNotification('Flushed Redis Permission Cache')}
                    className="px-4 py-2 rounded-lg text-xs font-medium border transition-colors hover:bg-white/[0.04]"
                    style={{ borderColor: 'var(--border)', color: 'var(--foreground)' }}
                  >
                    ⚡ Flush RBAC Cache
                  </button>
                  <button
                    onClick={() => showNotification('Exporting System Audit Log as PDF...')}
                    className="px-4 py-2 rounded-lg text-xs font-medium border transition-colors hover:bg-white/[0.04]"
                    style={{ borderColor: 'var(--border)', color: 'var(--foreground)' }}
                  >
                    📄 Export Audit Logs (PDF)
                  </button>
                </div>
              </div>
            </div>

            {/* Right Column: Storage & Live Analytics */}
            <div className="flex flex-col gap-4">
              <div className="rounded-xl border p-5 flex flex-col gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <h3 className="text-sm font-semibold" style={{ fontFamily: 'Lexend' }}>Active Live Sessions</h3>
                <div className="space-y-3">
                  {[
                    { name: 'MATH 401 — Differential Eq', host: 'Dr. Vasquez', students: 38, room: 'livekit-room-401' },
                    { name: 'BIO 310 — CRISPR Workshop', host: 'Prof. Okonkwo', students: 55, room: 'livekit-room-310' },
                    { name: 'CS 301 — Graph Theory', host: 'Dr. Lee', students: 42, room: 'livekit-room-301' },
                  ].map((room, i) => (
                    <div key={i} className="p-3 rounded-lg border flex items-center justify-between" style={{ background: 'var(--muted)', borderColor: 'var(--border)' }}>
                      <div>
                        <p className="text-xs font-medium leading-tight">{room.name}</p>
                        <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>Host: {room.host}</p>
                      </div>
                      <div className="text-right">
                        <span className="mono text-xs px-2 py-0.5 rounded-full" style={{ background: 'var(--accent)22', color: 'var(--accent)' }}>
                          {room.students} online
                        </span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </>
      )}

      {activeTab === 'approvals' && (
        <div className="flex flex-col gap-4">
          <h2 className="text-sm font-semibold mono uppercase tracking-widest" style={{ color: 'var(--muted-foreground)' }}>
            Pending User Verification Queue
          </h2>
          <div className="rounded-xl border overflow-hidden" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
            <table className="w-full text-sm">
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border)' }}>
                  {['Applicant', 'Email', 'Role', 'Department', 'Submitted', 'Actions'].map(h => (
                    <th key={h} className="text-left px-5 py-3 text-xs mono uppercase tracking-widest font-medium" style={{ color: 'var(--muted-foreground)' }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {approvalsList.map((item, i) => (
                  <tr key={item.id} className="transition-colors hover:bg-white/[0.02]" style={{ borderTop: i > 0 ? '1px solid var(--border)' : undefined }}>
                    <td className="px-5 py-3 font-medium" style={{ fontFamily: 'Lexend' }}>{item.name}</td>
                    <td className="px-5 py-3 mono text-xs" style={{ color: 'var(--muted-foreground)' }}>{item.email}</td>
                    <td className="px-5 py-3">
                      <span className="mono text-xs px-2 py-0.5 rounded" style={{ background: 'var(--primary)22', color: 'var(--primary)' }}>
                        {item.role}
                      </span>
                    </td>
                    <td className="px-5 py-3 text-xs">{item.dept}</td>
                    <td className="px-5 py-3 mono text-xs" style={{ color: 'var(--muted-foreground)' }}>{item.date}</td>
                    <td className="px-5 py-3">
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => handleApprove(item.id, item.name)}
                          className="px-3 py-1 rounded-lg text-xs font-medium transition-opacity hover:opacity-80"
                          style={{ background: 'var(--accent)', color: 'var(--accent-foreground)' }}
                        >
                          Approve
                        </button>
                        <button
                          onClick={() => handleReject(item.id, item.name)}
                          className="px-3 py-1 rounded-lg text-xs font-medium transition-opacity hover:opacity-80 border"
                          style={{ borderColor: '#ef444466', color: '#ef4444' }}
                        >
                          Reject
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
                {approvalsList.length === 0 && (
                  <tr>
                    <td colSpan={6} className="text-center py-8 text-xs text-slate-400">
                      No pending user registration requests. All clear!
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {activeTab === 'institutions' && (
        <div className="flex flex-col gap-4">
          <div className="flex justify-between items-center">
            <h2 className="text-sm font-semibold mono uppercase tracking-widest" style={{ color: 'var(--muted-foreground)' }}>
              Schools & Faculty Units
            </h2>
            <button
              onClick={() => showNotification('Opening New School Setup Modal')}
              className="px-4 py-2 rounded-lg text-xs font-semibold"
              style={{ background: 'var(--primary)', color: '#fff' }}
            >
              + Add New School
            </button>
          </div>

          <div className="grid grid-cols-2 gap-4">
            {schools.map(sch => (
              <div key={sch.id} className="rounded-xl border p-5 flex flex-col gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <div className="flex justify-between items-start">
                  <div>
                    <span className="mono text-xs" style={{ color: 'var(--primary)' }}>{sch.id}</span>
                    <h3 className="font-semibold text-base" style={{ fontFamily: 'Lexend' }}>{sch.name}</h3>
                    <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>Dean: {sch.dean}</p>
                  </div>
                  <span className="mono text-xs px-2 py-0.5 rounded-full" style={{ background: 'var(--accent)22', color: 'var(--accent)' }}>
                    Active
                  </span>
                </div>
                <div className="grid grid-cols-3 gap-2 pt-2 border-t text-center" style={{ borderColor: 'var(--border)' }}>
                  <div>
                    <p className="mono text-xs text-slate-400">Departments</p>
                    <p className="font-semibold text-sm">{sch.depts}</p>
                  </div>
                  <div>
                    <p className="mono text-xs text-slate-400">Teachers</p>
                    <p className="font-semibold text-sm">{sch.teachers}</p>
                  </div>
                  <div>
                    <p className="mono text-xs text-slate-400">Students</p>
                    <p className="font-semibold text-sm">{sch.students}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {activeTab === 'audit' && (
        <div className="flex flex-col gap-4">
          <h2 className="text-sm font-semibold mono uppercase tracking-widest" style={{ color: 'var(--muted-foreground)' }}>
            Security & Compliance Audit Trail (Immutable)
          </h2>
          <div className="rounded-xl border overflow-hidden" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
            <table className="w-full text-sm">
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border)' }}>
                  {['Log ID', 'Timestamp', 'Actor', 'Action', 'Target / Details', 'IP Address'].map(h => (
                    <th key={h} className="text-left px-5 py-3 text-xs mono uppercase tracking-widest font-medium" style={{ color: 'var(--muted-foreground)' }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {auditLogs.map((log, i) => (
                  <tr key={log.id} className="transition-colors hover:bg-white/[0.02]" style={{ borderTop: i > 0 ? '1px solid var(--border)' : undefined }}>
                    <td className="px-5 py-3 mono text-xs font-bold" style={{ color: 'var(--primary)' }}>{log.id}</td>
                    <td className="px-5 py-3 mono text-xs" style={{ color: 'var(--muted-foreground)' }}>{log.timestamp}</td>
                    <td className="px-5 py-3 font-medium text-xs">{log.actor}</td>
                    <td className="px-5 py-3">
                      <span className="mono text-xs px-2 py-0.5 rounded" style={{ background: 'var(--muted)', color: 'var(--foreground)' }}>
                        {log.action}
                      </span>
                    </td>
                    <td className="px-5 py-3 text-xs">{log.target}</td>
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
