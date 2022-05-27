// imports
const { ethers, run, network } = require("hardhat")

// async main
async function main() {
  const ExchangeFactory = await ethers.getContractFactory("Exchange")
  console.log("Deploying contract...")

  const exchange = await ExchangeFactory.deploy(1000000000, 1000000000, 0, 5)
  await exchange.deployed()
  const dx = 100000
  console.log(`Deployed contract to: ${exchange.address}`)
  // what happens when we deploy to our hardhat network?
  if (network.config.chainId === 4 && process.env.ETHERSCAN_API_KEY) {
    console.log("Waiting for block confirmations...")
    await exchange.deployTransaction.wait(6)
    await verify(exchange.address, [])
  }

  // var x = await exchange.getX()
  // var y = await exchange.getY()
  // var qnum = await exchange.getQnum()
  // console.log(`Current Value for qnum is: ${qnum}`)
  // console.log(`Current Value for X is: ${x}`)
  // console.log(`Current Value for Y is: ${y}`)

  // console.log("DOING SWAP...")

  // var transactionResponse = await exchange.swapXforY(dx)
  // await transactionResponse.wait(1)
  // var dy = await exchange.getDY()
  // console.log(`DY out is: ${dy}`)

  // x = await exchange.getX()
  // y = await exchange.getY()

  // qnum = await exchange.getQnum()
  // console.log(`Current Value for qnum is: ${qnum}`)

  // console.log(`Current Value for X is: ${x}`)
  // console.log(`Current Value for Y is: ${y}`)

  // console.log("DOING SWAP...")

  // transactionResponse = await exchange.swapXforY(dx)
  // await transactionResponse.wait(1)
  // dy = await exchange.getDY()
  // console.log(`DY out is: ${dy}`)

  // x = await exchange.getX()
  // y = await exchange.getY()
  // qnum = await exchange.getQnum()
  // console.log(`Current Value for qnum is: ${qnum}`)

  // console.log(`Current Value for X is: ${x}`)
  // console.log(`Current Value for Y is: ${y}`)

  // console.log("DOING SWAP...")

  // transactionResponse = await exchange.swapXforY(dx)
  // await transactionResponse.wait(1)
  // dy = await exchange.getDY()
  // console.log(`DY out is: ${dy}`)

  // x = await exchange.getX()
  // y = await exchange.getY()
  // qnum = await exchange.getQnum()
  // console.log(`Current Value for qnum is: ${qnum}`)

  // console.log(`Current Value for X is: ${x}`)
  // console.log(`Current Value for Y is: ${y}`)

  // console.log("DOING SWAP...")

  // transactionResponse = await exchange.swapXforY(dx)
  // await transactionResponse.wait(1)
  // var dy = await exchange.getDY()
  // console.log(`DY out is: ${dy}`)

  // x = await exchange.getX()
  // y = await exchange.getY()
  // qnum = await exchange.getQnum()
  // console.log(`Current Value for qnum is: ${qnum}`)

  // console.log(`Current Value for X is: ${x}`)
  // console.log(`Current Value for Y is: ${y}`)

  // console.log("DOING SWAP...")

  // transactionResponse = await exchange.swapXforY(dx)
  // await transactionResponse.wait(1)
  // var dy = await exchange.getDY()
  // console.log(`DY out is: ${dy}`)

  // x = await exchange.getX()
  // y = await exchange.getY()
  // qnum = await exchange.getQnum()
  // console.log(`Current Value for qnum is: ${qnum}`)

  // console.log(`Current Value for X is: ${x}`)
  // console.log(`Current Value for Y is: ${y}`)

  // console.log("DOING SWAP...")

  // transactionResponse = await exchange.swapXforY(dx)
  // await transactionResponse.wait(1)
  // var dy = await exchange.getDY()
  // console.log(`DY out is: ${dy}`)

  // x = await exchange.getX()
  // y = await exchange.getY()
  // qnum = await exchange.getQnum()
  // console.log(`Current Value for qnum is: ${qnum}`)

  // console.log(`Current Value for X is: ${x}`)
  // console.log(`Current Value for Y is: ${y}`)

  // console.log("DOING SWAP...")

  // transactionResponse = await exchange.swapXforY(dx)
  // await transactionResponse.wait(1)
  // var dy = await exchange.getDY()
  // console.log(`DY out is: ${dy}`)

  // transactionResponse = await exchange.log2IntegerPart(10000000000)
  // console.log(transactionResponse.toString())
}

// async function verify(contractAddress, args) {
const verify = async (contractAddress, args) => {
  console.log("Verifying contract...")
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    })
  } catch (e) {
    if (e.message.toLowerCase().includes("already verified")) {
      console.log("Already Verified!")
    } else {
      console.log(e)
    }
  }
}

// main
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
