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

-- Insert sample data for testing
-- ID 1: Used by "Retrieve a proposal by ID" test (expects "Gisela Torres")
INSERT INTO talk_proposals (id, speaker_name, talk_title, abstract, duration, category, experience_level, email, status) VALUES
(1, 'Gisela Torres', 'Introduction to Generative AI', 'Discover how Generative AI is transforming development workflows and best practices for integration', '60 minutes', 'AI', 'Advanced', 'giselatb@outlook.com', 'pending');

-- ID 2: Used by "Reject a pending proposal" test (needs to stay in pending status)
INSERT INTO talk_proposals (id, speaker_name, talk_title, abstract, duration, category, experience_level, email, status) VALUES
(2, 'Gisela Torres', 'Building Custom MCP Servers', 'Learn how to create and deploy Model Context Protocol servers for advanced AI integrations', '45 minutes', 'Backend', 'Intermediate', 'giselatb@outlook.com', 'pending');

-- ID 3: Used by "Cannot change status of an already approved proposal" test (needs to be approved)
INSERT INTO talk_proposals (id, speaker_name, talk_title, abstract, duration, category, experience_level, email, status) VALUES
(3, 'Gisela Torres', 'Azure DevOps for Platform Engineering', 'Automate your entire development pipeline with Azure DevOps and CI/CD best practices', '60 minutes', 'DevOps', 'Advanced', 'giselatb@outlook.com', 'approved');

-- Additional proposals for general tests
INSERT INTO talk_proposals (speaker_name, talk_title, abstract, duration, category, experience_level, email, status) VALUES
('Gisela Torres', 'GitHub Copilot: From Basics to Advanced', 'Master GitHub Copilot for AI-powered code generation and productivity', '45 minutes', 'AI', 'Beginner', 'giselatb@outlook.com', 'pending'),
('Gisela Torres', 'GitHub Platform: Enterprise Solutions', 'Explore GitHub Enterprise features for scalable collaborative development', '60 minutes', 'Platform', 'Advanced', 'giselatb@outlook.com', 'pending'),
('Gisela Torres', 'Platform Engineering Best Practices', 'Build robust internal developer platforms that scale with your organization', '50 minutes', 'DevOps', 'Advanced', 'giselatb@outlook.com', 'pending'),
('Gisela Torres', 'AI-Driven Development with GitHub Copilot and LLMs', 'Combine GitHub Copilot with Large Language Models for next-generation development', '45 minutes', 'AI', 'Intermediate', 'giselatb@outlook.com', 'pending');
