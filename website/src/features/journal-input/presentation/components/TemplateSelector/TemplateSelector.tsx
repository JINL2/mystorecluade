/**
 * TemplateSelector Component
 * Displays transaction templates as clickable chips above the Excel table
 */

import React from 'react';
import type { TransactionTemplate } from '../../../domain/repositories/IJournalInputRepository';
import styles from './TemplateSelector.module.css';

export interface TemplateSelectorProps {
  templates: TransactionTemplate[];
  loading: boolean;
  onSelectTemplate: (templateId: string) => void;
}

export const TemplateSelector: React.FC<TemplateSelectorProps> = ({
  templates,
  loading,
  onSelectTemplate,
}) => {
  if (loading) {
    return (
      <div className={styles.container}>
        <div className={styles.loading}>Loading templates...</div>
      </div>
    );
  }

  if (templates.length === 0) {
    return null; // Don't show anything if no templates
  }

  return (
    <div className={styles.container}>
      <div className={styles.label}>Templates:</div>
      <div className={styles.templateList}>
        {templates.map((template) => (
          <button
            key={template.templateId}
            className={styles.templateChip}
            onClick={() => onSelectTemplate(template.templateId)}
            title={template.description || template.name}
          >
            <span className={styles.templateName}>{template.name}</span>
            {template.tags && template.tags.length > 0 && (
              <span className={styles.templateTags}>
                {template.tags.slice(0, 2).map((tag, idx) => (
                  <span key={idx} className={styles.tag}>
                    {tag}
                  </span>
                ))}
              </span>
            )}
          </button>
        ))}
      </div>
    </div>
  );
};

export default TemplateSelector;
