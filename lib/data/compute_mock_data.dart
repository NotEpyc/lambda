import '../models/compute.dart';

// Simple User class for mock data
class User {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
  });
}

class MockData {
  static final User sampleUser = User(
    id: 'user_1',
    email: 'creator@lambda.com',
    name: 'Alex Creator',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  static final List<ComputeJob> sampleJobs = [
    ComputeJob(
      id: 'job_1',
      name: 'AI Model Training - GPT Fine-tune',
      description: 'Fine-tuning GPT model on custom dataset for content generation',
      type: ComputeType.aiTraining,
      status: JobStatus.running,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      startedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      progress: 0.65,
      resources: ComputeResources(
        gpuCount: 4,
        gpuType: 'RTX 4090',
        cpuCores: 16,
        ramGB: 64,
        storageGB: 500,
        estimatedTime: const Duration(hours: 6),
      ),
      estimatedCost: 24.50,
    ),
    ComputeJob(
      id: 'job_2',
      name: '3D Animation Render',
      description: 'Rendering 30-second product animation in 4K',
      type: ComputeType.rendering3d,
      status: JobStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      startedAt: DateTime.now().subtract(const Duration(days: 1)),
      completedAt: DateTime.now().subtract(const Duration(hours: 8)),
      progress: 1.0,
      resources: ComputeResources(
        gpuCount: 2,
        gpuType: 'RTX 3080',
        cpuCores: 8,
        ramGB: 32,
        storageGB: 200,
        estimatedTime: const Duration(hours: 4),
      ),
      estimatedCost: 15.20,
      actualCost: 14.80,
      outputUrl: 'https://storage.lambda.com/renders/job_2_output.mp4',
    ),
    ComputeJob(
      id: 'job_3',
      name: 'Video Upscaling - 4K Enhancement',
      description: 'AI-powered video upscaling from 1080p to 4K',
      type: ComputeType.videoProcessing,
      status: JobStatus.queued,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      resources: ComputeResources(
        gpuCount: 1,
        gpuType: 'RTX 4070',
        cpuCores: 8,
        ramGB: 16,
        storageGB: 100,
        estimatedTime: const Duration(hours: 2),
      ),
      estimatedCost: 8.75,
    ),
    ComputeJob(
      id: 'job_4',
      name: 'Scientific Simulation',
      description: 'Molecular dynamics simulation for drug discovery',
      type: ComputeType.scientificComputing,
      status: JobStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      resources: ComputeResources(
        gpuCount: 8,
        gpuType: 'A100',
        cpuCores: 32,
        ramGB: 128,
        storageGB: 1000,
        estimatedTime: const Duration(hours: 12),
      ),
      estimatedCost: 96.00,
    ),
  ];

  static final List<ComputeNode> availableNodes = [
    ComputeNode(
      id: 'node_1',
      name: 'Lambda-GPU-01',
      status: NodeStatus.online,
      availableGpus: ['RTX 4090', 'RTX 4090', 'RTX 3080'],
      availableCpuCores: 24,
      availableRamGB: 96,
      pricePerHour: 3.50,
      location: 'US-West',
      reliability: 0.99,
      completedJobs: 1247,
    ),
    ComputeNode(
      id: 'node_2',
      name: 'Lambda-Render-02',
      status: NodeStatus.online,
      availableGpus: ['RTX 3080', 'RTX 3080'],
      availableCpuCores: 16,
      availableRamGB: 64,
      pricePerHour: 2.80,
      location: 'EU-Central',
      reliability: 0.97,
      completedJobs: 892,
    ),
    ComputeNode(
      id: 'node_3',
      name: 'Lambda-AI-03',
      status: NodeStatus.busy,
      availableGpus: ['A100', 'A100', 'A100', 'A100'],
      availableCpuCores: 32,
      availableRamGB: 256,
      pricePerHour: 8.00,
      location: 'US-East',
      reliability: 0.98,
      completedJobs: 2156,
    ),
    ComputeNode(
      id: 'node_4',
      name: 'Lambda-Crypto-04',
      status: NodeStatus.online,
      availableGpus: ['RTX 4070', 'RTX 4070', 'RTX 4070', 'RTX 4070'],
      availableCpuCores: 16,
      availableRamGB: 64,
      pricePerHour: 4.20,
      location: 'Asia-Pacific',
      reliability: 0.96,
      completedJobs: 743,
    ),
  ];

  static final Map<ComputeType, List<String>> computeTemplates = {
    ComputeType.aiTraining: [
      'GPT Fine-tuning',
      'Image Classification',
      'Object Detection',
      'Natural Language Processing',
      'Reinforcement Learning',
    ],
    ComputeType.aiInference: [
      'Real-time Image Processing',
      'Text Generation API',
      'Voice Recognition',
      'Recommendation Engine',
    ],
    ComputeType.rendering3d: [
      'Product Visualization',
      'Architectural Rendering',
      'Animation Sequences',
      'VFX Compositing',
    ],
    ComputeType.videoProcessing: [
      'AI Upscaling',
      'Color Grading',
      'Motion Tracking',
      'Format Conversion',
    ],
    ComputeType.scientificComputing: [
      'Molecular Dynamics',
      'Climate Modeling',
      'Fluid Dynamics',
      'Quantum Simulation',
    ],
    ComputeType.dataProcessing: [
      'Big Data Analytics',
      'ETL Pipelines',
      'Machine Learning Training',
      'Data Mining',
    ],
  };
}
