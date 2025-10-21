-- Create database and tables for Call for Paper application
USE callforpaper;

-- Table for talk proposals
CREATE TABLE IF NOT EXISTS talk_proposals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    speaker_name VARCHAR(255) NOT NULL,
    talk_title VARCHAR(255) NOT NULL,
    abstract TEXT NOT NULL,
    duration VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    experience_level VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for additional notes
CREATE TABLE IF NOT EXISTS proposal_notes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    proposal_id INT NOT NULL,
    notes TEXT,
    FOREIGN KEY (proposal_id) REFERENCES talk_proposals(id) ON DELETE CASCADE
);

-- Insert sample data
INSERT INTO talk_proposals (speaker_name, talk_title, abstract, duration, category, experience_level, email, status) VALUES
('Gisela Torres', 'Introduction to Docker', 'Learn the basics of Docker containerization', '30 minutes', 'DevOps', 'Beginner', 'john@email.com', 'pending'),
('Maria Garcia', 'Advanced React Patterns', 'Deep dive into advanced React patterns and best practices', '45 minutes', 'Frontend', 'Advanced', 'maria@email.com', 'pending'),
('Carlos López', 'Machine Learning Basics', 'Introduction to machine learning concepts using Python', '60 minutes', 'AI/ML', 'Intermediate', 'carlos@email.com', 'pending'),
('Ana Rodríguez', 'Spring Boot Microservices', 'Building microservices with Spring Boot and Docker', '45 minutes', 'Backend', 'Intermediate', 'ana@email.com', 'pending'),
('David Chen', 'Kubernetes in Production', 'Real-world Kubernetes deployment strategies', '60 minutes', 'DevOps', 'Advanced', 'david@email.com', 'pending'),
('Sophie Dubois', 'Vue.js Best Practices', 'Writing maintainable Vue.js applications', '30 minutes', 'Frontend', 'Beginner', 'sophie@email.com', 'pending'),
('Miguel Santos', 'MongoDB for Developers', 'Document databases and MongoDB fundamentals', '45 minutes', 'Backend', 'Intermediate', 'miguel@email.com', 'pending'),
('Lisa Wong', 'Mobile App Security', 'Security best practices for mobile applications', '30 minutes', 'Mobile', 'Advanced', 'lisa@email.com', 'pending');
