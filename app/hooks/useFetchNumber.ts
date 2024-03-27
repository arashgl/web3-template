import { useState } from "react"
import CounterContract from "@/artifacts/contracts/Counter.sol/Counter.json"
import { ethers } from "hardhat"

const abi = CounterContract.abi
export const useFetchNumber = () => {
  const [number, setNumber] = useState(0)
  const getCount = async () => {
    if (typeof window?.ethereum !== "undefined") {
      const contract = new ethers.Contract(
        process.env.NEXT_PUBLIC_CONTRACT_ADDRESS,
        abi,
      )

      const count = await contract.count()
      console.log("count>>", count)
      setNumber(+count.toString())
    }
  }
  const increment = async () => {
    if (typeof window?.ethereum !== "undefined") {
      const provider = new ethers.BrowserProvider(window.ethereum)
      const signer = await provider.getSigner()
      const contract = new ethers.Contract(
        process.env.NEXT_PUBLIC_CONTRACT_ADDRESS,
        abi,
        signer,
      )
      await contract.getFunction("inc").call(null)
      const count = await contract.count()
      console.log(count, "qwe")
      setNumber(+count.toString())
    }
  }

  const showOwner = async () => {
    if (typeof window?.ethereum !== "undefined") {
      const contract = new ethers.Contract(
        process.env.NEXT_PUBLIC_CONTRACT_ADDRESS,
        abi,
      )
      const owner = await contract.owner().catch((e) => console.log(e))
      console.log("owner>>", owner)
    }
  }
  return { number, getCount, increment, showOwner }
}
