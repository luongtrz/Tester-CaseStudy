# OrangeHRM White-Box Testing Guide

> Hướng dẫn nhanh cho Tester/QA đọc và tra cứu source code OrangeHRM

---

## 🏗️ Kiến Trúc

**Pattern:** Symfony + Plugin-Based + Service-Dao-Entity

```
Request → API → Service → Dao → Entity → Database
```

**4 Layers chính:**
- **API** (`Api/*.php`): REST endpoints, input validation
- **Service** (`Service/*.php`): Business logic, validation rules
- **Dao** (`Dao/*.php`): Database queries
- **Entity** (`entity/*.php`): Database models

---

## 📁 Cấu Trúc

```
src/plugins/orangehrm[PluginName]/
├── Api/              # REST endpoints
├── Service/          # Business logic ⭐ ĐỌC ĐÂY TRƯỚC
├── Dao/              # Database queries
├── entity/           # Database models
├── test/             # Unit tests
└── config/routes.yaml
```

---

## 🧩 22 Plugins Chính

| Plugin | Chức năng |
|--------|-----------|
| **AdminPlugin** | Users, Roles, Locations |
| **PimPlugin** | Employee profiles |
| **LeavePlugin** | Quản lý nghỉ phép |
| **TimePlugin** | Chấm công, timesheet |
| **RecruitmentPlugin** | Tuyển dụng |
| **PerformancePlugin** | Đánh giá |
| **ClaimPlugin** | Hoàn ứng chi phí |
| **AttendancePlugin** | Điểm danh |

---

## 🔍 Tra Cứu Code

### Tìm Business Logic
```bash
# 1. Xác định plugin
cd src/plugins/orangehrmLeavePlugin/

# 2. Xem Service
ls Service/  # → LeaveApplicationService.php

# 3. Đọc method
# Service chứa validate*() và business logic
```

### Tìm Validation Rules

**3 nơi chứa validation:**

1. **API Input** → `getValidationRuleFor*()`:
```php
new Rule(Rules::LENGTH, [5, 40])  // Username 5-40 ký tự
```

2. **Service Logic** → `validate*()` methods:
```php
if ($balance < $days) throw new Exception();
```

3. **Entity Constraints** → Annotations:
```php
@ORM\Column(length=40, unique=true)
```

### Tìm Test Cases

```bash
# Test cases cho thấy edge cases
ls src/plugins/orangehrmLeavePlugin/test/Service/
```

---

## 📐 Quick Commands

```bash
# Tìm API endpoints
ls src/plugins/orangehrmLeavePlugin/Api/

# Tìm Service
ls src/plugins/orangehrmLeavePlugin/Service/

# Tìm validation rule
grep -r "Rules::LENGTH" src/plugins/orangehrmAdminPlugin/Api/

# Tìm entities
find src/plugins -name "entity" -type d

# Tìm Dao
find src/plugins -name "*Dao.php"
```

---

## ⚠️ Lưu Ý Khi Test

1. **Permission Check** - Luôn check quyền trước khi thực hiện action
2. **Soft Delete** - Nhiều entity dùng `deleted_at` thay vì xóa thật
3. **Cascade** - Xóa parent có thể xóa luôn children
4. **Transaction** - Multi-step operation fail → rollback toàn bộ

---

## 🎯 Workflow Test 1 Feature

1. Đọc `test/` → Hiểu edge cases
2. Đọc `Api/` → Xem input validation
3. Đọc `Service/` → Xem business logic ⭐
4. Đọc `Dao/` → Xem queries
5. Đọc `entity/` → Xem database schema

---

**Nguyên tắc:** Luôn đọc Service layer trước - đây là nơi chứa toàn bộ business logic!
