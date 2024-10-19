enum EntityType { Permission, Role }

enum AccountAction { ACTIVATE }

enum AuditAction { CREATE, UPDATE, DELETE }

enum DeliveryStatusEnum {
  PENDING_ASSIGNMENT,
  ASSIGNED,
  IN_PROGRESS,
  DELIVERED,
  CANCELED,
  DISPUTED
}

enum BusinessStatusEnum { STARTED, IN_PROGRESS, COMPLETED, CANCELED }

enum DriverStatusEnum { STARTED, IN_PROGRESS, COMPLETED, CANCELED }

enum SaleStatusEnum { STARTED, IN_PROGRESS, COMPLETED, CANCELED }
