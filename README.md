# Karate Automation Core Service

## 1️⃣ Install Java JDK
- Karate needs **Java 11+** (use 17 or 21 for stable).
- **Windows**: download from [Adoptium](https://adoptium.net/temurin/releases), install `.msi`.
- **macOS**: `brew install openjdk@17`
- **Ubuntu/Debian**: `sudo apt install openjdk-17-jdk -y`
- Check:  
```bash
java -version
```

## 2️⃣ Install Maven
### **Windows**
- Download the binary zip from [Maven](https://maven.apache.org/download.cgi) (choose **Binary zip archive**, e.g., `apache-maven-3.9.x-bin.zip`)
- Extract to a folder, e.g.: C:\Program Files\apache-maven-3.9.x
- Set Environment Variables:
    + MAVEN_HOME = C:\Program Files\apache-maven-3.9.x
    + Add `%MAVEN_HOME%\bin` to `Path`
### **macOS (Homebrew)**
- `brew install maven`
### **Ubuntu / Debian**
- `sudo apt update`
- `sudo apt install maven -y`
### Check:  
```bash
mvn -version
```

---

# Cleans the project and Installs the built version/package
```bash
mvn clean install
```

# Run tests
- Run specific test class:
```bash
mvn test -Dtest=RunAll
```
- Run all tests:
```bash
mvn clean test
```

# Reports
- After run, report is at:
```bash
target/surefire-reports/karate-summary.html
```

![alt text](<Screenshot 2025-09-29 004954.png>)