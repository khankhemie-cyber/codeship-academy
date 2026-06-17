import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

// Returns a print-ready HTML certificate. Browsers can "Save as PDF" from print.
// (No server-side PDF binary is generated to keep the dependency surface small.)
export async function GET(
  _req: NextRequest,
  { params }: { params: { id: string } }
) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const { data: cert } = await supabase
    .from('certificates')
    .select('id, level, issued_at, student_id, profiles!certificates_student_id_fkey(display_name)')
    .eq('id', params.id)
    .single()

  if (!cert) return NextResponse.json({ error: 'Not found' }, { status: 404 })

  const studentName = (cert as any).profiles?.display_name ?? 'Student'
  const level = (cert.level ?? '').charAt(0).toUpperCase() + (cert.level ?? '').slice(1)
  const issued = new Date(cert.issued_at).toLocaleDateString('en-CA', { dateStyle: 'long' })

  const html = `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>CODEship Academy Certificate</title>
<style>
  @page { size: landscape; margin: 0; }
  body { font-family: Nunito, Arial, sans-serif; margin: 0; background: #F8F9FE; }
  .cert { width: 1000px; max-width: 95vw; margin: 40px auto; background: #fff; border: 12px solid #F5C518;
          border-radius: 16px; padding: 60px; text-align: center; box-shadow: 0 10px 40px rgba(30,33,64,0.15); }
  .brand { color: #F5C518; font-weight: 800; letter-spacing: 2px; }
  h1 { color: #1E2140; font-size: 42px; margin: 18px 0 6px; }
  .sub { color: #3A3D5C; text-transform: uppercase; letter-spacing: 4px; font-size: 13px; }
  .name { font-size: 34px; color: #1E2140; font-weight: 800; margin: 24px 0; }
  .level { font-size: 22px; color: #2B2D42; }
  .meta { color: #6b7280; margin-top: 28px; font-size: 14px; }
  .print { margin: 20px; text-align: center; }
  button { background: #1E2140; color: #fff; border: none; padding: 12px 24px; border-radius: 10px; font-weight: 700; cursor: pointer; }
  @media print { .print { display: none; } body { background: #fff; } .cert { box-shadow: none; margin: 0; } }
</style>
</head>
<body>
  <div class="print"><button onclick="window.print()">Print / Save as PDF</button></div>
  <div class="cert">
    <div class="brand">CODESHIP ACADEMY</div>
    <div class="sub">Certificate of Completion</div>
    <h1>🎓</h1>
    <p class="sub">This certifies that</p>
    <div class="name">${studentName}</div>
    <p class="level">has successfully completed the <strong>${level} Level</strong></p>
    <p class="meta">Issued ${issued} &middot; CODEship Academy Inc., Oshawa, Ontario</p>
  </div>
</body>
</html>`

  return new NextResponse(html, {
    status: 200,
    headers: { 'Content-Type': 'text/html; charset=utf-8' },
  })
}
