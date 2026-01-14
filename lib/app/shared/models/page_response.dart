/// 分页响应类
/// 通用的分页数据结构
class PageResponse<T> {
  /// 当前页码
  final int page;

  /// 每页数量
  final int pageSize;

  /// 总数量
  final int total;

  /// 总页数
  final int totalPages;

  /// 数据列表
  final List<T> items;

  /// 构造函数
  const PageResponse({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.items,
  });

  /// 空的分页响应
  const PageResponse.empty({
    this.page = 1,
    this.pageSize = 20,
  })  : total = 0,
        totalPages = 0,
        items = const [];

  /// 从JSON创建
  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PageResponse<T>(
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? json['page_size'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? json['total_pages'] as int? ?? 0,
      items: (json['items'] as List? ?? json['list'] as List? ?? json['data'] as List? ?? [])
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 从单个列表创建（不带分页信息）
  factory PageResponse.fromList(List<T> items, {int page = 1, int pageSize = 20}) {
    return PageResponse<T>(
      page: page,
      pageSize: pageSize,
      total: items.length,
      totalPages: (items.length / pageSize).ceil(),
      items: items,
    );
  }

  /// 判断是否有更多数据
  bool get hasMore => page < totalPages;

  /// 判断是否为第一页
  bool get isFirstPage => page == 1;

  /// 判断是否为最后一页
  bool get isLastPage => page >= totalPages;

  /// 判断是否为空
  bool get isEmpty => items.isEmpty;

  /// 判断是否不为空
  bool get isNotEmpty => items.isNotEmpty;

  /// 下一页页码
  int get nextPage => hasMore ? page + 1 : page;

  /// 上一页页码
  int get previousPage => page > 1 ? page - 1 : 1;

  /// 映射数据项
  PageResponse<R> map<R>(R Function(T item) mapper) {
    return PageResponse<R>(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      items: items.map(mapper).toList(),
    );
  }

  /// 合并另一个分页响应（用于加载更多）
  PageResponse<T> merge(PageResponse<T> other) {
    return PageResponse<T>(
      page: other.page,
      pageSize: pageSize,
      total: other.total,
      totalPages: other.totalPages,
      items: [...items, ...other.items],
    );
  }

  /// 复制并修改
  PageResponse<T> copyWith({
    int? page,
    int? pageSize,
    int? total,
    int? totalPages,
    List<T>? items,
  }) {
    return PageResponse<T>(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return 'PageResponse{page: $page, pageSize: $pageSize, total: $total, items: ${items.length}}';
  }
}

