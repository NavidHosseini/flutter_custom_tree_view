import 'package:flutter/material.dart';
import 'package:flutter_custom_tree_view/flutter_custom_tree_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LazyTreeViewExample(),
    );
  }
}

class LazyTreeViewExample extends StatefulWidget {
  const LazyTreeViewExample({super.key});
  @override
  State<LazyTreeViewExample> createState() => _LazyTreeViewExampleState();
}

class _LazyTreeViewExampleState extends State<LazyTreeViewExample> {
  // Root node with only first-level children pre-loaded
  late TreeNode rootNode;

  @override
  void initState() {
    super.initState();
    _initializeRootNode();
  }

  void _initializeRootNode() {
    rootNode = TreeNode(
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
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.add),
              alignment: Alignment.topRight,
            ),
            childrenPadding: EdgeInsets.only(right: 12, left: 15),
          ),
        ),
        TreeNode(
          title: 'Marketing',
          value: 'marketing',
          key: 'dept_mkt',
          customUi: TreeNodeUi(
            iconColor: Colors.green,
          ),
        ),
        TreeNode(
          title: 'HR',
          value: 'hr',
          key: 'dept_hr',
          customUi: TreeNodeUi(
            iconColor: Colors.purple,
          ),
        ),
      ],
    );
  }

  // Simulate API call to load children
  Future<List<TreeNode>> _loadChildren(TreeNode parentNode) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (parentNode.key == 'dept_eng') {
      return [
        TreeNode(
          title: 'Frontend Team',
          value: 'frontend',
          key: 'team_frontend',
        ),
        TreeNode(
          title: 'Backend Team',
          value: 'backend',
          key: 'team_backend',
        ),
        TreeNode(
          title: 'QA Team',
          value: 'qa',
          key: 'team_qa',
        ),
      ];
    } else if (parentNode.key == 'dept_mkt') {
      return [
        TreeNode(
          title: 'Digital Marketing',
          value: 'digital',
          key: 'team_digital',
        ),
        TreeNode(
          title: 'Content Team',
          value: 'content',
          key: 'team_content',
        ),
      ];
    } else if (parentNode.key == 'dept_hr') {
      return [
        TreeNode(
          title: 'Recruitment',
          value: 'recruitment',
          key: 'team_recruitment',
        ),
        TreeNode(
          title: 'Employee Relations',
          value: 'relations',
          key: 'team_relations',
        ),
      ];
    } else if (parentNode.key.startsWith('team_') ?? false) {
      return List.generate(
        3,
        (i) => TreeNode(
          title: 'Employee ${i + 1}',
          value: 'emp_${parentNode.key}_$i',
          key: 'emp_${parentNode.key}_$i',
          isLastItem: true,
          customUi: TreeNodeUi(
            title: Text('Employee ${i + 1}', style: const TextStyle(color: Colors.grey)),
            leading: const Icon(Icons.person, size: 20),
          ),
        ),
      );
    }

    return [];
  }

  final treeViewController = TreeViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lazy Tree View Example"),
      ),
      body: Column(
        children: [
          Expanded(
            child: TreeViewCustom(
              divider: Divider(),
              showSearch: true,
              controller: treeViewController,
              showRootTitle: false,
              root: rootNode,
              searchFieldUi:
                  TreeViewSearchUi(hintText: 'Find nodes...', prefixIcon: Icon(Icons.search_off), fillColor: Colors.grey[200], filled: true),
              onLastItemClick: (roadmap, node) {
                String path = roadmap.map((n) => n.title).join(' > ');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected employee: ${node.title}\nPath: $path')));
              },
              onPressToLoadChildren: (node) async {
                if (!node.completer.isCompleted) {
                  final children = await _loadChildren(node);
                  node.completer.complete(children);
                }
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  treeViewController.collapseAllNodes();
                },
                child: Text("collapseAllNodes")),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  treeViewController.toggleNode('dept_eng');
                },
                child: Text("toggleNode")),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  treeViewController.expandNode('dept_eng');
                },
                child: Text("expandNode")),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  treeViewController.collapseNode('dept_eng');
                },
                child: Text("collapseNode")),
          ),
        ],
      ),
    );
  }
}
