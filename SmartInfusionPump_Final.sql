-- Smart Infusion Pump Simulator Database
CREATE DATABASE SmartInfusionPump;
GO
USE SmartInfusionPump;
GO

-- Base user entity for all roles (Nurse, Doctor, Admin)
CREATE TABLE [User] (
    userId UNIQUEIDENTIFIER NOT NULL,
    username NVARCHAR(50) NOT NULL UNIQUE,
    passwordHash NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) NOT NULL,
    createdAt DATETIME2 NOT NULL,
    lastLogin DATETIME2,
    PRIMARY KEY (userId)
);
GO

-- Drug library with safety limits managed by Doctor
CREATE TABLE [Drug] (
    drugId UNIQUEIDENTIFIER NOT NULL,
    [name] NVARCHAR(100) NOT NULL UNIQUE,
    concentration DECIMAL(10,2) NOT NULL,
    concentrationUnit NVARCHAR(20) NOT NULL,
    defaultRate DECIMAL(10,2) NOT NULL,
    rateUnit NVARCHAR(10) DEFAULT 'mL/hr',
    hardLimitLow DECIMAL(10,2) NOT NULL,
    hardLimitHigh DECIMAL(10,2) NOT NULL,
    softLimitLow DECIMAL(10,2),
    softLimitHigh DECIMAL(10,2),
    createdBy UNIQUEIDENTIFIER NOT NULL,
    createdAt DATETIME2 NOT NULL,
    updatedBy UNIQUEIDENTIFIER,
    updatedAt DATETIME2,
    PRIMARY KEY (drugId)
);
GO

-- Represents a single infusion session operated by Nurse
CREATE TABLE [InfusionSession] (
    sessionId UNIQUEIDENTIFIER NOT NULL,
    userId UNIQUEIDENTIFIER NOT NULL,
    drugId UNIQUEIDENTIFIER NOT NULL,
    rate DECIMAL(10,2) NOT NULL,
    totalVolume DECIMAL(10,2) NOT NULL,
    volumeInfused DECIMAL(10,2) DEFAULT 0,
    [status] NVARCHAR(20) NOT NULL DEFAULT 'Idle',
    startTime DATETIME2,
    endTime DATETIME2,
    bolusEnabled BIT DEFAULT 0,
    kvoEnabled BIT DEFAULT 0,
    kvoRate DECIMAL(10,2),
    batteryLevel INT DEFAULT 100,
    PRIMARY KEY (sessionId)
);
GO

-- Alarms triggered during infusion sessions
CREATE TABLE [Alarm] (
    alarmId UNIQUEIDENTIFIER NOT NULL,
    sessionId UNIQUEIDENTIFIER NOT NULL,
    [type] NVARCHAR(30) NOT NULL,
    severity NVARCHAR(20) NOT NULL,
    [timestamp] DATETIME2 NOT NULL,
    acknowledged BIT DEFAULT 0,
    acknowledgedBy UNIQUEIDENTIFIER,
    acknowledgedAt DATETIME2,
    resolved BIT DEFAULT 0,
    resolvedAt DATETIME2,
    description NVARCHAR(MAX),
    PRIMARY KEY (alarmId)
);
GO

-- Immutable audit trail for all changes (regulatory requirement)
CREATE TABLE [AuditLog] (
    logId UNIQUEIDENTIFIER NOT NULL,
    userId UNIQUEIDENTIFIER NOT NULL,
    [action] NVARCHAR(100) NOT NULL,
    entityType NVARCHAR(50),
    entityId UNIQUEIDENTIFIER,
    oldValue NVARCHAR(MAX),
    newValue NVARCHAR(MAX),
    [timestamp] DATETIME2 NOT NULL,
    ipAddress NVARCHAR(45),
    sessionId UNIQUEIDENTIFIER,
    PRIMARY KEY (logId)
);
GO

-- System-wide parameters configurable by Admin
CREATE TABLE [SystemConfiguration] (
    configId UNIQUEIDENTIFIER NOT NULL,
    [key] NVARCHAR(100) NOT NULL UNIQUE,
    [value] NVARCHAR(MAX) NOT NULL,
    description NVARCHAR(MAX),
    updatedBy UNIQUEIDENTIFIER NOT NULL,
    updatedAt DATETIME2 NOT NULL,
    PRIMARY KEY (configId)
);
GO

-- Predefined test scenarios for system validation
CREATE TABLE [TestScenario] (
    scenarioId UNIQUEIDENTIFIER NOT NULL,
    [name] NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    script NVARCHAR(MAX) NOT NULL,
    createdBy UNIQUEIDENTIFIER NOT NULL,
    createdAt DATETIME2 NOT NULL,
    PRIMARY KEY (scenarioId)
);
GO

-- Records of test scenario executions
CREATE TABLE [TestExecution] (
    executionId UNIQUEIDENTIFIER NOT NULL,
    scenarioId UNIQUEIDENTIFIER NOT NULL,
    executedBy UNIQUEIDENTIFIER NOT NULL,
    executedAt DATETIME2 NOT NULL,
    [status] NVARCHAR(20) NOT NULL,
    resultDetails NVARCHAR(MAX),
    PRIMARY KEY (executionId)
);
GO

-- Generated reports (infusion summary, alarm frequency, etc.)
CREATE TABLE [Report] (
    reportId UNIQUEIDENTIFIER NOT NULL,
    [type] NVARCHAR(30) NOT NULL,
    generatedBy UNIQUEIDENTIFIER NOT NULL,
    generatedAt DATETIME2 NOT NULL,
    parameters NVARCHAR(MAX),
    filePath NVARCHAR(255),
    [format] NVARCHAR(10) DEFAULT 'PDF',
    PRIMARY KEY (reportId)
);
GO

-- Real-time event log for infusion sessions (preview for Nurse)
CREATE TABLE [EventLog] (
    eventId UNIQUEIDENTIFIER NOT NULL,
    sessionId UNIQUEIDENTIFIER NOT NULL,
    eventType NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX) NOT NULL,
    [timestamp] DATETIME2 NOT NULL,
    userId UNIQUEIDENTIFIER,
    PRIMARY KEY (eventId)
);
GO

-- Foreign Key Constraints

ALTER TABLE [Drug]
    ADD CONSTRAINT [drug_created_by_user]
    FOREIGN KEY (createdBy) REFERENCES [User](userId);
GO

ALTER TABLE [Drug]
    ADD CONSTRAINT [drug_updated_by_user]
    FOREIGN KEY (updatedBy) REFERENCES [User](userId);
GO

ALTER TABLE [InfusionSession]
    ADD CONSTRAINT [session_performed_by_user]
    FOREIGN KEY (userId) REFERENCES [User](userId);
GO

ALTER TABLE [InfusionSession]
    ADD CONSTRAINT [session_uses_drug]
    FOREIGN KEY (drugId) REFERENCES [Drug](drugId);
GO

ALTER TABLE [Alarm]
    ADD CONSTRAINT [alarm_belongs_to_session]
    FOREIGN KEY (sessionId) REFERENCES [InfusionSession](sessionId);
GO

ALTER TABLE [Alarm]
    ADD CONSTRAINT [alarm_acknowledged_by_user]
    FOREIGN KEY (acknowledgedBy) REFERENCES [User](userId);
GO

ALTER TABLE [AuditLog]
    ADD CONSTRAINT [audit_log_created_by_user]
    FOREIGN KEY (userId) REFERENCES [User](userId);
GO

ALTER TABLE [SystemConfiguration]
    ADD CONSTRAINT [config_updated_by_user]
    FOREIGN KEY (updatedBy) REFERENCES [User](userId);
GO

ALTER TABLE [TestScenario]
    ADD CONSTRAINT [scenario_created_by_user]
    FOREIGN KEY (createdBy) REFERENCES [User](userId);
GO

ALTER TABLE [TestExecution]
    ADD CONSTRAINT [execution_for_scenario]
    FOREIGN KEY (scenarioId) REFERENCES [TestScenario](scenarioId);
GO

ALTER TABLE [TestExecution]
    ADD CONSTRAINT [execution_by_user]
    FOREIGN KEY (executedBy) REFERENCES [User](userId);
GO

ALTER TABLE [Report]
    ADD CONSTRAINT [report_generated_by_user]
    FOREIGN KEY (generatedBy) REFERENCES [User](userId);
GO

ALTER TABLE [EventLog]
    ADD CONSTRAINT [event_log_belongs_to_session]
    FOREIGN KEY (sessionId) REFERENCES [InfusionSession](sessionId);
GO

ALTER TABLE [EventLog]
    ADD CONSTRAINT [event_log_created_by_user]
    FOREIGN KEY (userId) REFERENCES [User](userId);
GO
