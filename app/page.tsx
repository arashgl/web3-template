'use client'
import { useFetchNumber } from '@/app/hooks/useFetchNumber'
import { useEffect } from 'react'

export default function Page() {
  const { number, getCount, increment, showOwner } = useFetchNumber()

  return (
    <div>
      <h1>Hello, Next.js! {number}</h1>
      <button onClick={getCount}>Get Count!</button>
      <button onClick={increment}>Increament</button>
      <button onClick={showOwner}>show owner</button>
    </div>
  )
}
