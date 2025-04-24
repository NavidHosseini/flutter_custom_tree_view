# Flutter Tree View Package

## Features
- Hierarchical tree structure display
- Customizable node UI
- Built-in search functionality
- Lazy loading support
- Path tracking for nodes
- Material Design compliant


## Basic Usage
```dart
import 'package:flutter_custom_tree_view/flutter_custom_tree_view.dart';

final rootNode = TreeNode(
      title: 'Company Structure',
      value: 'company',
      key: 'root',
      customUi: TreeNodeUi(
        title: const Text('Company Structure', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.business),
      ),
      preLoadedChildren: [
        TreeNode(
          title: 'Engineering',
          value: 'engineering',
          key: 'dept_eng',
          customUi: TreeNodeUi(
            iconColor: Colors.blue,
            trailing: IconButton(onPressed: () {}, icon: Icon(Icons.add), alignment: Alignment.topRight),
            childrenPadding: EdgeInsets.only(right: 12, left: 15),
          ),
        ),
        TreeNode(title: 'Marketing', value: 'marketing', key: 'dept_mkt', customUi: TreeNodeUi(iconColor: Colors.green)),
        TreeNode(title: 'HR', value: 'hr', key: 'dept_hr', customUi: TreeNodeUi(iconColor: Colors.purple)),
      ],
    );
    
TreeViewCustom(
  root: rootNode,
  onLastItemClick: (path, node) {
    print('Selected: ${node.title}');
  },
  onPressToLoadChildren: (node) {
    node.completer.complete([
      TreeNode(title: 'New child', key: 'new')
    ]);
  },
  showSearch: true,
);
```

## Node Customization
```dart
TreeNode(
  title: 'Custom Node',
  key: 'node1',
  customUi: TreeNodeUi(
    title: Text('Custom Title'),
    leading: Icon(Icons.folder),
    backgroundColor: Colors.blue[50],
    iconColor: Colors.blue,
    childrenPadding: EdgeInsets.only(left: 20),
  ),
  preLoadedChildren: [...]
)
```

## Search Customization
```dart
TreeViewSearchUi(
  hintText: 'Search nodes...',
  prefixIcon: Icon(Icons.search),
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    filled: true,
    fillColor: Colors.grey[100],
  ),
  style: TextStyle(fontSize: 14),
)
```
## Complete Example 
[example flutter_custom_tree_view](https://github.com/NavidHosseini/flutter_custom_tree_view/blob/master/example/main.dart);

## API Reference

### TreeViewCustom
| Parameter | Type | Description |
|-----------|------|-------------|
| `root` | `TreeNode` | Root node of the tree |
| `onLastItemClick` | `Function(List<String>, TreeNode)` | Leaf node click callback |
| `onPressToLoadChildren` | `Function(TreeNode)` | Lazy load children callback |
| `showSearch` | `bool` | Toggle search field visibility |
| `searchFieldUi` | `TreeViewSearchUi?` | Search field customization |

### TreeNode
| Property | Description |
|----------|-------------|
| `title` | Node display text |
| `key` | Unique identifier |
| `value` | Associated data |
| `isLastItem` | Marks as leaf node |
| `customUi` | Node styling options |
| `preLoadedChildren` | Child nodes |
| `completer` | For async child loading |

### TreeNodeUi
Supports all `ExpansionTile` properties including:
- `title`, `subtitle`, `leading`, `trailing`
- `backgroundColor`, `iconColor`
- `childrenPadding`, `tilePadding`
- Various state-based styling options

### TreeViewSearchUi
Supports standard `TextField` properties:
- `decoration`, `style`
- `keyboardType`, `textInputAction`
- `hintText`, `prefixIcon`
- Various appearance controls

## License
MIT License

