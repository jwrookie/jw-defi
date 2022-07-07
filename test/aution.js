const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Aution", function () {
    beforeEach(async () => {
        [owner, seller, buyer1, buyer2] = await ethers.getSigners();
        const Aution = await ethers.getContractFactory("Aution");
        aution = await Aution.connect(owner).deploy(seller.address,"name");
    })

    it("test case 1", async function () {
        aution.connect(buyer1).aution({value:10000000000})
        console.log(await owner.getBalance())
        console.log(await seller.getBalance())
        console.log(await buyer1.getBalance())
        console.log(await buyer2.getBalance())
    })
})