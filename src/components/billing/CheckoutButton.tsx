'use client'

export default function CheckoutButton({
  plan,
  label = 'Subscribe',
  className = 'btn-primary w-full',
}: {
  plan: string
  label?: string
  className?: string
}) {
  async function handleClick() {
    const res = await fetch('/api/stripe/checkout', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ plan }),
    })
    const data = await res.json()
    if (data.url) window.location.href = data.url
  }

  return (
    <button type="button" className={className} onClick={handleClick}>
      {label}
    </button>
  )
}
