const { expect } = require('chai')

describe('Birthday', function () {
  let Birthday, birthday, dev, owner, alice, bob, charlie, dan, eve

  beforeEach(async function () {
    ;[dev, owner, alice, bob, charlie, dan, eve] = await ethers.getSigners()
    Birthday = await ethers.getContractFactory('Birthday')
    await birthday.deployed()
  })

  describe('Deployement', function () {
    it('', async function () {

    })
  })

  describe('Allowance system', function () {
    // Tester le système d'allowance ici
  })
  describe('Token transfers', function () {
    beforeEach(async function () {
        expect(await birthday.connect(owner).transfer(alice.address, TRANSFER_SUPPLY))
    })
    it('transfers tokens from sender to receipient', async function () {
        await birthday.connect(alice).transfer(bob.address, TRANSFER_SUPPLY)
        expect(await birthday.balanceOf(bob.address)).to.equal(TRANSFER_SUPPLY)
    })
    it('allowance of ammount of tokens from sender to spender', async function () {
        await birthday.connect(alice).allowance(bob.address, TRANSFER_SUPPLY)
        expect(await birthday.allowanceOf(alice.address, bob.address)).to.equal(TRANSFER_SUPPLY)
    })
    it('transferFrom tokens from sender to recipient', async function () {
        await birthday.connect(alice).allowance(bob.address, TRANSFER_SUPPLY)
        await birthday.connect(bob).transferFrom(alice.address, eve.address, TRANSFER_SUPPLY)
        expect(await birthday.balanceOf(eve.address)).to.equal(TRANSFER_SUPPLY)
    })
    it('emits event Transfer when transfer token', async function () {
        await expect(birthday.connect(alice).transfer(bob.address, TRANSFER_SUPPLY))
        .to.emit(birthday, 'Transfer')
        .withArgs(alice.address, bob.address, TRANSFER_SUPPLY)
    })
    it('emits event Transfer when transferFrom token', async function () {
        await birthday.connect(alice).allowance(bob.address, TRANSFER_SUPPLY)
        await expect(birthday.connect(bob).transferFrom(alice.address, eve.address, TRANSFER_SUPPLY))
        .to.emit(birthday, 'Transfer')
        .withArgs(alice.address, eve.address, TRANSFER_SUPPLY)
    })
  })
})