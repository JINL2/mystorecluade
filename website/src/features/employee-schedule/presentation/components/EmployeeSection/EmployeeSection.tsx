/**
 * EmployeeSection Component
 * Display employee list with drag support for schedule assignments
 */

import React from 'react';
import { LoadingAnimation } from '@/shared/components/common/LoadingAnimation';
import type { EmployeeSectionProps } from './EmployeeSection.types';
import styles from './EmployeeSection.module.css';

export const EmployeeSection: React.FC<EmployeeSectionProps> = ({
  employees,
  loading,
  draggedEmployeeId,
  showDragHint = true,
  onDragStart,
  onDragEnd,
}) => {
  if (loading) {
    return (
      <div className={styles.employeeSection}>
        <h3 className={styles.sectionTitle}>Employees</h3>
        <LoadingAnimation />
      </div>
    );
  }

  return (
    <div className={styles.employeeSection}>
      <h3 className={styles.sectionTitle}>
        Employees ({employees.length})
        {showDragHint && (
          <span className={styles.dragHint}>Drag employees to schedule cells</span>
        )}
      </h3>

      {employees.length === 0 ? (
        <div className={styles.noEmployees}>No employees found for this store</div>
      ) : (
        <div className={styles.employeeGrid}>
          {employees.map((employee) => (
            <div
              key={employee.userId}
              className={`${styles.employeeCard} ${draggedEmployeeId === employee.userId ? styles.dragging : ''}`}
              draggable={true}
              onDragStart={(e) => onDragStart(e, employee.userId)}
              onDragEnd={onDragEnd}
            >
              <div className={styles.employeeAvatar}>{employee.initials}</div>
              <div className={styles.employeeInfo}>
                <div className={styles.employeeName}>{employee.fullName}</div>
                <div className={styles.employeeRole}>{employee.displayRole}</div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default EmployeeSection;
