# LeftFilter Component

공용 좌측 필터 사이드바 컴포넌트입니다. 다양한 페이지에서 재사용 가능하도록 설계되었습니다.

## Features

- ✅ 6가지 섹션 타입 지원 (Sort, Multi-select, Radio, Toggle, Input, Custom)
- ✅ 완전히 커스터마이징 가능한 섹션 구성
- ✅ 반응형 디자인 (모바일에서 자동 숨김)
- ✅ 접기/펼치기 기능 (Sort 제외)
- ✅ 선택된 항목 개수 표시
- ✅ 깔끔한 Toss 디자인 스타일

## Basic Usage

```tsx
import { LeftFilter } from '@/shared/components/common/LeftFilter';
import type { FilterSection } from '@/shared/components/common/LeftFilter';

const MyPage = () => {
  const [sortType, setSortType] = useState('newest');
  const [selectedBrands, setSelectedBrands] = useState(new Set<string>());
  const [selectedCategories, setSelectedCategories] = useState(new Set<string>());

  const filterSections: FilterSection[] = [
    {
      id: 'sort',
      title: 'Sort by',
      type: 'sort',
      defaultExpanded: true,
      selectedValues: sortType,
      options: [
        { value: 'newest', label: 'Newest' },
        { value: 'oldest', label: 'Oldest' },
        { value: 'price_high', label: 'Price: High to Low' },
        { value: 'price_low', label: 'Price: Low to High' },
      ],
      onSelect: (value) => setSortType(value),
    },
    {
      id: 'brand',
      title: 'Brand',
      type: 'multiselect',
      defaultExpanded: false,
      showCount: true,
      selectedValues: selectedBrands,
      options: [
        { value: 'apple', label: 'Apple' },
        { value: 'samsung', label: 'Samsung' },
        { value: 'lg', label: 'LG' },
      ],
      emptyMessage: 'No brands available',
      onToggle: (value) => {
        const newSet = new Set(selectedBrands);
        if (newSet.has(value)) {
          newSet.delete(value);
        } else {
          newSet.add(value);
        }
        setSelectedBrands(newSet);
      },
      onClear: () => setSelectedBrands(new Set()),
    },
  ];

  return <LeftFilter sections={filterSections} width={240} topOffset={64} />;
};
```

## Section Types

### 1. Sort (정렬)
단일 선택 정렬 옵션. 항상 펼쳐진 상태로 표시됩니다.

```tsx
{
  id: 'sort',
  title: 'Sort by',
  type: 'sort',
  defaultExpanded: true,
  selectedValues: 'newest', // string
  options: [
    { value: 'newest', label: 'Newest' },
    { value: 'oldest', label: 'Oldest' },
  ],
  onSelect: (value) => setSortType(value),
}
```

### 2. Multi-select (다중 선택)
여러 항목을 선택할 수 있는 체크박스 스타일 필터입니다.

```tsx
{
  id: 'category',
  title: 'Category',
  type: 'multiselect',
  defaultExpanded: false,
  showCount: true, // 선택된 개수 표시
  selectedValues: new Set(['electronics', 'fashion']), // Set<string>
  options: [
    { value: 'electronics', label: 'Electronics' },
    { value: 'fashion', label: 'Fashion' },
    { value: 'food', label: 'Food & Beverage' },
  ],
  emptyMessage: 'No categories available',
  onToggle: (value) => toggleSelection(value),
  onClear: () => clearAllSelections(),
}
```

### 3. Radio (라디오 버튼)
단일 선택 라디오 버튼 필터입니다.

```tsx
{
  id: 'status',
  title: 'Status',
  type: 'radio',
  defaultExpanded: true,
  selectedValues: 'active', // string
  options: [
    { value: 'active', label: 'Active' },
    { value: 'inactive', label: 'Inactive' },
    { value: 'pending', label: 'Pending' },
  ],
  onSelect: (value) => setStatus(value),
}
```

### 4. Toggle (토글 버튼)
2-3개의 선택지를 토글 버튼으로 표시합니다.

```tsx
{
  id: 'view',
  title: 'View Mode',
  type: 'toggle',
  defaultExpanded: true,
  selectedValues: 'grid', // string
  options: [
    { value: 'grid', label: 'Grid' },
    { value: 'list', label: 'List' },
  ],
  onSelect: (value) => setViewMode(value),
}
```

### 5. Input (텍스트 입력)
텍스트 입력 필드입니다.

```tsx
{
  id: 'search',
  title: 'Search',
  type: 'input',
  defaultExpanded: true,
  selectedValues: searchText, // string
  placeholder: 'Enter search term...',
  onInputChange: (value) => setSearchText(value),
}
```

### 6. Custom (커스텀 컨텐츠)
완전히 커스텀한 React 컴포넌트를 삽입할 수 있습니다.

```tsx
{
  id: 'custom',
  title: 'Custom Filter',
  type: 'custom',
  defaultExpanded: true,
  customContent: (
    <div>
      <p>Your custom component here</p>
      <button onClick={handleCustomAction}>Action</button>
    </div>
  ),
}
```

## Props

### LeftFilterProps

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `sections` | `FilterSection[]` | required | 필터 섹션 배열 |
| `width` | `number` | `240` | 사이드바 너비 (px) |
| `topOffset` | `number` | `64` | 상단 오프셋 (px) - Navbar 높이 |
| `className` | `string` | `''` | 추가 CSS 클래스 |
| `onSectionExpandToggle` | `(sectionId: string, isExpanded: boolean) => void` | `undefined` | 섹션 펼침/접힘 콜백 |

### FilterSection

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| `id` | `string` | ✅ | 섹션 고유 ID |
| `title` | `string` | ✅ | 섹션 제목 |
| `type` | `FilterSectionType` | ✅ | 섹션 타입 |
| `defaultExpanded` | `boolean` | ❌ | 기본 펼침 상태 |
| `showCount` | `boolean` | ❌ | 선택 개수 표시 (multiselect용) |
| `options` | `FilterOption[]` | ❌ | 선택 옵션 목록 |
| `selectedValues` | `Set<string> \| string` | ❌ | 선택된 값 |
| `placeholder` | `string` | ❌ | Input 타입 placeholder |
| `emptyMessage` | `string` | ❌ | 옵션 없을 때 메시지 |
| `onSelect` | `(value: string) => void` | ❌ | 단일 선택 콜백 |
| `onToggle` | `(value: string) => void` | ❌ | 토글 콜백 |
| `onClear` | `() => void` | ❌ | 전체 삭제 콜백 |
| `onInputChange` | `(value: string) => void` | ❌ | 입력 변경 콜백 |
| `customContent` | `React.ReactNode` | ❌ | 커스텀 컨텐츠 |

### FilterOption

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| `value` | `string` | ✅ | 옵션 값 |
| `label` | `string` | ✅ | 옵션 표시 텍스트 |
| `icon` | `React.ReactNode` | ❌ | 옵션 아이콘 |
| `disabled` | `boolean` | ❌ | 비활성화 여부 |

## Advanced Examples

### With Icons

```tsx
const filterSections: FilterSection[] = [
  {
    id: 'sort',
    title: 'Sort by',
    type: 'sort',
    defaultExpanded: true,
    selectedValues: sortType,
    options: [
      {
        value: 'newest',
        label: 'Newest',
        icon: (
          <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2Z"/>
          </svg>
        ),
      },
    ],
    onSelect: setSortType,
  },
];
```

### With Disabled Options

```tsx
const filterSections: FilterSection[] = [
  {
    id: 'status',
    title: 'Status',
    type: 'multiselect',
    options: [
      { value: 'active', label: 'Active' },
      { value: 'inactive', label: 'Inactive', disabled: true },
      { value: 'pending', label: 'Pending' },
    ],
    selectedValues: selectedStatuses,
    onToggle: toggleStatus,
  },
];
```

### Multiple Filter Sections

```tsx
const filterSections: FilterSection[] = [
  {
    id: 'sort',
    title: 'Sort by',
    type: 'sort',
    defaultExpanded: true,
    selectedValues: sortType,
    options: [...],
    onSelect: setSortType,
  },
  {
    id: 'category',
    title: 'Category',
    type: 'multiselect',
    defaultExpanded: false,
    showCount: true,
    selectedValues: selectedCategories,
    options: [...],
    onToggle: toggleCategory,
    onClear: clearCategories,
  },
  {
    id: 'brand',
    title: 'Brand',
    type: 'multiselect',
    defaultExpanded: false,
    showCount: true,
    selectedValues: selectedBrands,
    options: [...],
    onToggle: toggleBrand,
    onClear: clearBrands,
  },
  {
    id: 'price',
    title: 'Price Range',
    type: 'custom',
    defaultExpanded: true,
    customContent: <PriceRangeSlider />,
  },
];
```

## Layout Integration

LeftFilter는 sticky positioning을 사용하므로, 부모 레이아웃에서 다음과 같이 사용하세요:

```tsx
<div style={{ display: 'flex', gap: '24px' }}>
  <LeftFilter sections={filterSections} width={240} topOffset={64} />
  <div style={{ flex: 1 }}>
    {/* Main content */}
  </div>
</div>
```

## Responsive Design

- **Desktop (>1024px)**: 240px 너비로 표시
- **Tablet (768px-1024px)**: 220px 너비로 표시
- **Mobile (<768px)**: 자동으로 숨김 처리

모바일에서는 별도의 드롭다운 필터 UI를 구현하는 것을 권장합니다.

## Migration from FilterSidebar

기존 FilterSidebar에서 마이그레이션하는 예시:

```tsx
// Before (FilterSidebar)
<FilterSidebar
  filterType={filterType}
  selectedBrandFilter={selectedBrandFilter}
  selectedCategoryFilter={selectedCategoryFilter}
  brands={uniqueBrands}
  categories={uniqueCategories}
  onFilterChange={setFilterType}
  onBrandFilterToggle={toggleBrandFilter}
  onCategoryFilterToggle={toggleCategoryFilter}
  onClearBrandFilter={clearBrandFilter}
  onClearCategoryFilter={clearCategoryFilter}
/>

// After (LeftFilter)
const filterSections: FilterSection[] = [
  {
    id: 'sort',
    title: 'Sort by',
    type: 'sort',
    defaultExpanded: true,
    selectedValues: filterType,
    options: [
      { value: 'newest', label: 'Newest' },
      { value: 'oldest', label: 'Oldest' },
      { value: 'price_high', label: 'Price: High to Low' },
      { value: 'price_low', label: 'Price: Low to High' },
    ],
    onSelect: setFilterType,
  },
  {
    id: 'category',
    title: 'Category',
    type: 'multiselect',
    defaultExpanded: false,
    showCount: true,
    selectedValues: selectedCategoryFilter,
    options: uniqueCategories.map(cat => ({ value: cat, label: cat })),
    emptyMessage: 'No categories available',
    onToggle: toggleCategoryFilter,
    onClear: clearCategoryFilter,
  },
  {
    id: 'brand',
    title: 'Brand',
    type: 'multiselect',
    defaultExpanded: false,
    showCount: true,
    selectedValues: selectedBrandFilter,
    options: uniqueBrands.map(brand => ({ value: brand, label: brand })),
    emptyMessage: 'No brands available',
    onToggle: toggleBrandFilter,
    onClear: clearBrandFilter,
  },
];

<LeftFilter sections={filterSections} width={240} topOffset={64} />
```

## Best Practices

1. **섹션 ID는 고유하게**: 각 섹션의 `id`는 반드시 고유해야 합니다.
2. **Sort는 항상 첫 번째**: Sort 타입 섹션은 가장 위에 배치하는 것이 UX상 좋습니다.
3. **defaultExpanded 활용**: 중요한 필터는 기본적으로 펼쳐두세요.
4. **showCount 사용**: Multi-select 타입에서는 `showCount`를 활성화하여 사용자에게 선택 개수를 알려주세요.
5. **emptyMessage 제공**: 옵션이 없을 때를 대비해 명확한 메시지를 제공하세요.
6. **onClear 제공**: Multi-select에서는 전체 삭제 기능을 제공하세요.

## Architecture Compliance

✅ ARCHITECTURE.md 준수:
- `/shared/components/common/` 위치
- TSX 파일 크기: ~9KB (15KB 제한 내)
- CSS 파일 크기: ~6KB (20KB 제한 내)
- Types 파일 분리
- CSS Modules 사용
- Toss Design System 컬러 사용
