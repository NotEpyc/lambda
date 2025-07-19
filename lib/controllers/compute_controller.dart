import 'package:flutter/foundation.dart';
import '../models/compute.dart';
import '../data/compute_mock_data.dart';

class ComputeController extends ChangeNotifier {
  List<ComputeJob> _jobs = [];
  List<ComputeNode> _nodes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ComputeJob> get jobs => _jobs;
  List<ComputeNode> get nodes => _nodes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<ComputeJob> get runningJobs => 
      _jobs.where((job) => job.status == JobStatus.running).toList();
  
  List<ComputeJob> get recentJobs => 
      _jobs.take(5).toList();

  double get totalSpentThisMonth {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    return _jobs
        .where((job) => 
            job.createdAt.isAfter(startOfMonth) && 
            job.actualCost != null)
        .fold(0.0, (sum, job) => sum + (job.actualCost ?? 0));
  }

  int get completedJobsCount => 
      _jobs.where((job) => job.status == JobStatus.completed).length;

  List<ComputeNode> get availableNodes => 
      _nodes.where((node) => node.status == NodeStatus.online).toList();

  ComputeController() {
    loadJobs();
    loadNodes();
  }

  Future<void> loadJobs() async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
      _jobs = List.from(MockData.sampleJobs);
      _clearError();
    } catch (e) {
      _setError('Failed to load compute jobs: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadNodes() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate API call
      _nodes = List.from(MockData.availableNodes);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load compute nodes: $e');
    }
  }

  Future<void> createJob({
    required String name,
    required String description,
    required ComputeType type,
    required ComputeResources resources,
  }) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate API call
      
      final newJob = ComputeJob(
        id: 'job_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: description,
        type: type,
        status: JobStatus.pending,
        createdAt: DateTime.now(),
        resources: resources,
        estimatedCost: _calculateEstimatedCost(resources),
      );

      _jobs.insert(0, newJob);
      _clearError();
    } catch (e) {
      _setError('Failed to create compute job: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> cancelJob(String jobId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate API call
      
      final jobIndex = _jobs.indexWhere((job) => job.id == jobId);
      if (jobIndex != -1) {
        final job = _jobs[jobIndex];
        final updatedJob = ComputeJob(
          id: job.id,
          name: job.name,
          description: job.description,
          type: job.type,
          status: JobStatus.cancelled,
          createdAt: job.createdAt,
          startedAt: job.startedAt,
          completedAt: DateTime.now(),
          progress: job.progress,
          resources: job.resources,
          estimatedCost: job.estimatedCost,
          actualCost: job.actualCost,
          outputUrl: job.outputUrl,
          errorMessage: job.errorMessage,
        );
        _jobs[jobIndex] = updatedJob;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to cancel job: $e');
    }
  }

  List<ComputeJob> searchJobs(String query) {
    if (query.isEmpty) return _jobs;
    
    final lowercaseQuery = query.toLowerCase();
    return _jobs.where((job) =>
        job.name.toLowerCase().contains(lowercaseQuery) ||
        job.description.toLowerCase().contains(lowercaseQuery) ||
        job.type.displayName.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }

  List<ComputeJob> filterJobsByType(ComputeType? type) {
    if (type == null) return _jobs;
    return _jobs.where((job) => job.type == type).toList();
  }

  List<ComputeJob> filterJobsByStatus(JobStatus? status) {
    if (status == null) return _jobs;
    return _jobs.where((job) => job.status == status).toList();
  }

  double _calculateEstimatedCost(ComputeResources resources) {
    // Base pricing calculation
    double gpuCost = resources.gpuCount * 2.0; // $2/hour per GPU
    double cpuCost = resources.cpuCores * 0.1; // $0.1/hour per CPU core
    double ramCost = resources.ramGB * 0.01; // $0.01/hour per GB RAM
    
    double totalHourlyCost = gpuCost + cpuCost + ramCost;
    double estimatedHours = resources.estimatedTime.inHours.toDouble();
    
    return totalHourlyCost * estimatedHours;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
