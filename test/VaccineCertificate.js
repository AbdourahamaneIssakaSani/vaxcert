const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('VaccineCertificate', function () {
    let VaccineCertificate;
    let vaccineCertificate;
    let owner;
    let addr1;
    let addr2;
    let addr3;

    beforeEach(async function () {
        VaccineCertificate = await ethers.getContractFactory('VaccineCertificate');
        [owner, addr1, addr2, addr3] = await ethers.getSigners();
        vaccineCertificate = await VaccineCertificate.deploy();
        await vaccineCertificate.addAuthority(addr1.address);
    });

    it('Should set the right authority', async function () {
        expect(await vaccineCertificate.authorities(owner.address)).to.equal(true);
    });

    it('Should add and remove an authority', async function () {
        await vaccineCertificate.addAuthority(addr2.address);
        expect(await vaccineCertificate.authorities(addr2.address)).to.equal(true);
        await vaccineCertificate.removeAuthority(addr2.address);
        expect(await vaccineCertificate.authorities(addr2.address)).to.equal(false);
    });

    it('Should issue a certificate', async function () {
        await vaccineCertificate.connect(addr1).issueCertificate(addr2.address, 'Alice', 'COVID-19', 1625097600);
        const certificate = await vaccineCertificate.certificates(addr2.address);
        expect(certificate.valid).to.equal(true);
        expect(certificate.issuer).to.equal(addr1.address);
    });

    it('Should revoke a certificate', async function () {
        await vaccineCertificate.connect(addr1).issueCertificate(addr2.address, 'Alice', 'COVID-19', 1625097600);
        await vaccineCertificate.connect(addr1).revokeCertificate(addr2.address);
        const certificate = await vaccineCertificate.certificates(addr2.address);
        expect(certificate.revoked).to.equal(true);
    });

    it('Should not revoke a certificate issued by another authority', async function () {
        await vaccineCertificate.connect(addr1).issueCertificate(addr2.address, 'Alice', 'COVID-19', 1625097600);
        await expect(vaccineCertificate.connect(owner).revokeCertificate(addr2.address))
            .to.be.revertedWith('Cannot revoke certificates issued by another authority');
    });

    it('Should verify a certificate', async function () {
        await vaccineCertificate.connect(addr1).issueCertificate(addr2.address, 'Alice', 'COVID-19', 1625097600);
        const isValid = await vaccineCertificate.verifyCertificate(addr2.address);
        expect(isValid).to.equal(true);
    });

    it('Should get certificate details', async function () {
        await vaccineCertificate.connect(addr1).issueCertificate(addr2.address, 'Alice', 'COVID-19', 1625097600);
        const certificateDetails = await vaccineCertificate.getCertificateDetails(addr2.address);
        expect(certificateDetails[0]).to.equal('Alice');
        expect(certificateDetails[1]).to.equal('COVID-19');
        expect(certificateDetails[2]).to.equal(1625097600);
        expect(certificateDetails[3]).to.equal(true);
        expect(certificateDetails[4]).to.equal(false);
        expect(certificateDetails[5]).to.equal(addr1.address);
    });

    it('Should get the issuer of a certificate', async function () {
        await vaccineCertificate.connect(addr1).issueCertificate(addr2.address, 'Alice', 'COVID-19', 1625097600);
        const issuer = await vaccineCertificate.getIssuer(addr2.address);
        expect(issuer).to.equal(addr1.address);
    });
});
