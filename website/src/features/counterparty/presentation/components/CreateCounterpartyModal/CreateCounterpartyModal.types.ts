/**
 * CreateCounterpartyModal Type Definitions
 */

import { TossSelectorOption } from '@/shared/components/selectors/TossSelector/TossSelector.types';

export interface CreateCounterpartyModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSubmit: () => Promise<void>;
  companyOptions: TossSelectorOption[];
}
