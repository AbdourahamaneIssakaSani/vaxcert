// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title VaccineCertificate
 * @dev A contract for managing vaccine certificates using blockchain technology.
 */
contract VaccineCertificate {
    // Mapping to store authority addresses
    mapping(address => bool) public authorities;

    // Certificate structure
    struct Certificate {
        string name;
        string vaccination;
        uint256 date;
        bool valid;
        bool revoked;
        address issuer;
    }

    // Mapping to store certificates by recipient address
    mapping(address => Certificate) public certificates;

    // Events for issuing, revoking, and verifying certificates
    event CertificateIssued(address indexed recipient, string name, string vaccination, uint256 date, address issuer);
    event CertificateRevoked(address indexed recipient, address issuer);
    event CertificateVerified(address indexed recipient, address verifier, uint256 timestamp);

    /**
     * @dev Modifier to restrict actions to only authorized authorities.
     */
    modifier onlyAuthority() {
        require(authorities[msg.sender], "Only an authorized authority can perform this action");
        _;
    }

    /**
     * @dev Constructor to set the initial deploying address as an authority.
     */
    constructor() {
        authorities[msg.sender] = true;
    }

    /**
     * @dev Function to add a new authority.
     * @param authority The address of the new authority.
     */
    function addAuthority(address authority) public onlyAuthority {
        authorities[authority] = true;
    }

    /**
     * @dev Function to remove an existing authority.
     * @param authority The address of the authority to remove.
     */
    function removeAuthority(address authority) public onlyAuthority {
        authorities[authority] = false;
    }

    /**
     * @dev Function to issue a certificate.
     * @param recipient The address of the certificate recipient.
     * @param name The name of the recipient.
     * @param vaccination The type of vaccination.
     * @param date The date of vaccination.
     */
    function issueCertificate(
        address recipient,
        string memory name,
        string memory vaccination,
        uint256 date
    ) public onlyAuthority {
        certificates[recipient] = Certificate(name, vaccination, date, true, false, msg.sender);
        emit CertificateIssued(recipient, name, vaccination, date, msg.sender);
    }

    /**
     * @dev Function to revoke a certificate.
     * @param recipient The address of the certificate recipient.
     */
    function revokeCertificate(address recipient) public onlyAuthority {
        require(certificates[recipient].issuer == msg.sender, "Cannot revoke certificates issued by another authority");
        certificates[recipient].revoked = true;
        emit CertificateRevoked(recipient, msg.sender);
    }

    /**
     * @dev Function to verify a certificate.
     * @param recipient The address of the certificate recipient.
     * @return bool indicating the validity of the certificate.
     */
    function verifyCertificate(address recipient) public view returns (bool) {
        // log verification attempt
        // emit CertificateVerified(recipient, msg.sender, block.timestamp);
        return certificates[recipient].valid && !certificates[recipient].revoked;
    }

    /**
     * @dev Function to get a certificate.
     * @param recipient The address of the certificate recipient.
     * @return Certificate of the recipient.
     */
    function getCertificate(address recipient) public view returns (Certificate memory) {
        return certificates[recipient];
    }

    /**
     * @dev Function to get the issuer of a certificate.
     * @param recipient The address of the certificate recipient.
     * @return address of the issuer.
     */
    function getIssuer(address recipient) public view returns (address) {
        return certificates[recipient].issuer;
    }

    /**
     * @dev Function to get the details of a certificate.
     * @param recipient The address of the certificate recipient.
     * @return Certificate details including name, vaccination type, date, validity, revocation status, and issuer.
     */
    function getCertificateDetails(address recipient) public view returns (string memory, string memory, uint256, bool, bool, address) {
        Certificate memory cert = certificates[recipient];
        return (cert.name, cert.vaccination, cert.date, cert.valid, cert.revoked, cert.issuer);
    }
}
