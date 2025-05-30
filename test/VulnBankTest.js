const { expect } = require("chai");

describe("VulnBank", function () {
    let vulnBank, attacker;

    beforeEach(async function () {
        const VulnBank = await ethers.getContractFactory("VulnBank");
        vulnBank = await VulnBank.deploy();
        await vulnBank.deployed();

        [deployer, attacker] = await ethers.getSigners();
    });

    it("allows deposits and withdrawals", async function () {
        await vulnBank.connect(attacker).deposit({ value: ethers.utils.parseEther("1") });
        await vulnBank.connect(attacker).withdraw(ethers.utils.parseEther("1"));
    });
});
