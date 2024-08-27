// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentDataOwnership {
    // Mapping of student IDs to their corresponding data
    mapping (address => StudentData) public studentData;

    // Struct to represent student data
    struct StudentData {
        string name;
        string email;
        string institution;
        uint256[] grades; // array of grades
        string[] courses; // array of courses taken
        string[] certifications; // array of certifications earned
        bool isDataShared; // flag to indicate if data is shared with third parties
    }

    // Event emitted when a student updates their data
    event StudentDataUpdated(address indexed student, string data);

    // Event emitted when a student shares their data with a third party
    event StudentDataShared(address indexed student, address indexed thirdParty);

    // Event emitted when a student revokes access to their data
    event StudentDataRevoked(address indexed student, address indexed thirdParty);

    // Modifier to check if the caller is the student owner
    modifier onlyStudentOwner(address _student) {
        require(msg.sender == _student, "Only the student owner can perform this action");
        _;
    }

    // Function to create a new student data record
    function createStudentData(string memory _name, string memory _email, string memory _institution) public {
        address student = msg.sender;
        studentData[student] = StudentData(_name, _email, _institution, new uint256[](0), new string[](0), new string[](0), false);
        emit StudentDataUpdated(student, "Created new student data record");
    }

    // Function to update student data
    function updateStudentData(string memory _name, string memory _email, string memory _institution) public onlyStudentOwner(msg.sender) {
        studentData[msg.sender].name = _name;
        studentData[msg.sender].email = _email;
        studentData[msg.sender].institution = _institution;
        emit StudentDataUpdated(msg.sender, "Updated student data record");
    }

    // Function to add a new grade to the student's record
    function addGrade(uint256 _grade) public onlyStudentOwner(msg.sender) {
        studentData[msg.sender].grades.push(_grade);
        emit StudentDataUpdated(msg.sender, "Added new grade to student data record");
    }

    // Function to add a new course to the student's record
    function addCourse(string memory _course) public onlyStudentOwner(msg.sender) {
        studentData[msg.sender].courses.push(_course);
        emit StudentDataUpdated(msg.sender, "Added new course to student data record");
    }

    // Function to add a new certification to the student's record
    function addCertification(string memory _certification) public onlyStudentOwner(msg.sender) {
        studentData[msg.sender].certifications.push(_certification);
        emit StudentDataUpdated(msg.sender, "Added new certification to student data record");
    }

    // Function to share student data with a third party
    function shareData(address _thirdParty) public onlyStudentOwner(msg.sender) {
        studentData[msg.sender].isDataShared = true;
        emit StudentDataShared(msg.sender, _thirdParty);
    }

    // Function to revoke access to student data
    function revokeAccess(address _thirdParty) public onlyStudentOwner(msg.sender) {
        studentData[msg.sender].isDataShared = false;
        emit StudentDataRevoked(msg.sender, _thirdParty);
    }

    // Function to get student data
    function getStudentData(address _student) public view returns (StudentData memory) {
        return studentData[_student];
    }
}