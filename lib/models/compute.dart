class ComputeJob {
  final String id;
  final String name;
  final String description;
  final ComputeType type;
  final JobStatus status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double? progress;
  final ComputeResources resources;
  final double estimatedCost;
  final double? actualCost;
  final String? outputUrl;
  final String? errorMessage;

  ComputeJob({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.progress,
    required this.resources,
    required this.estimatedCost,
    this.actualCost,
    this.outputUrl,
    this.errorMessage,
  });

  factory ComputeJob.fromJson(Map<String, dynamic> json) {
    return ComputeJob(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: ComputeType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      status: JobStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      startedAt: json['started_at'] != null 
          ? DateTime.parse(json['started_at'] as String) 
          : null,
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'] as String) 
          : null,
      progress: json['progress']?.toDouble(),
      resources: ComputeResources.fromJson(json['resources']),
      estimatedCost: json['estimated_cost'].toDouble(),
      actualCost: json['actual_cost']?.toDouble(),
      outputUrl: json['output_url'] as String?,
      errorMessage: json['error_message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'progress': progress,
      'resources': resources.toJson(),
      'estimated_cost': estimatedCost,
      'actual_cost': actualCost,
      'output_url': outputUrl,
      'error_message': errorMessage,
    };
  }
}

class ComputeResources {
  final int gpuCount;
  final String gpuType;
  final int cpuCores;
  final int ramGB;
  final int storageGB;
  final Duration estimatedTime;

  ComputeResources({
    required this.gpuCount,
    required this.gpuType,
    required this.cpuCores,
    required this.ramGB,
    required this.storageGB,
    required this.estimatedTime,
  });

  factory ComputeResources.fromJson(Map<String, dynamic> json) {
    return ComputeResources(
      gpuCount: json['gpu_count'] as int,
      gpuType: json['gpu_type'] as String,
      cpuCores: json['cpu_cores'] as int,
      ramGB: json['ram_gb'] as int,
      storageGB: json['storage_gb'] as int,
      estimatedTime: Duration(minutes: json['estimated_time_minutes'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gpu_count': gpuCount,
      'gpu_type': gpuType,
      'cpu_cores': cpuCores,
      'ram_gb': ramGB,
      'storage_gb': storageGB,
      'estimated_time_minutes': estimatedTime.inMinutes,
    };
  }
}

class ComputeNode {
  final String id;
  final String name;
  final NodeStatus status;
  final List<String> availableGpus;
  final int availableCpuCores;
  final int availableRamGB;
  final double pricePerHour;
  final String location;
  final double reliability;
  final int completedJobs;

  ComputeNode({
    required this.id,
    required this.name,
    required this.status,
    required this.availableGpus,
    required this.availableCpuCores,
    required this.availableRamGB,
    required this.pricePerHour,
    required this.location,
    required this.reliability,
    required this.completedJobs,
  });

  factory ComputeNode.fromJson(Map<String, dynamic> json) {
    return ComputeNode(
      id: json['id'] as String,
      name: json['name'] as String,
      status: NodeStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      availableGpus: List<String>.from(json['available_gpus']),
      availableCpuCores: json['available_cpu_cores'] as int,
      availableRamGB: json['available_ram_gb'] as int,
      pricePerHour: json['price_per_hour'].toDouble(),
      location: json['location'] as String,
      reliability: json['reliability'].toDouble(),
      completedJobs: json['completed_jobs'] as int,
    );
  }
}

enum ComputeType {
  aiTraining,
  aiInference,
  rendering3d,
  videoProcessing,
  cryptoMining,
  scientificComputing,
  dataProcessing,
}

enum JobStatus {
  pending,
  queued,
  running,
  completed,
  failed,
  cancelled,
}

enum NodeStatus {
  online,
  offline,
  busy,
  maintenance,
}

extension ComputeTypeExtension on ComputeType {
  String get displayName {
    switch (this) {
      case ComputeType.aiTraining:
        return 'AI Training';
      case ComputeType.aiInference:
        return 'AI Inference';
      case ComputeType.rendering3d:
        return '3D Rendering';
      case ComputeType.videoProcessing:
        return 'Video Processing';
      case ComputeType.cryptoMining:
        return 'Crypto Mining';
      case ComputeType.scientificComputing:
        return 'Scientific Computing';
      case ComputeType.dataProcessing:
        return 'Data Processing';
    }
  }

  String get icon {
    switch (this) {
      case ComputeType.aiTraining:
        return '🧠';
      case ComputeType.aiInference:
        return '🤖';
      case ComputeType.rendering3d:
        return '🎨';
      case ComputeType.videoProcessing:
        return '🎬';
      case ComputeType.cryptoMining:
        return '⛏️';
      case ComputeType.scientificComputing:
        return '🔬';
      case ComputeType.dataProcessing:
        return '📊';
    }
  }
}
