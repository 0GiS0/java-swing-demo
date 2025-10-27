#!/bin/bash

# Script to create a visual index of test reports
# Extracts real data from reports and creates an interactive HTML

set -e

REPORTS_DIR="target/test-reports"
CUCUMBER_JSON="target/cucumber-json-reports/cucumber.json"
SUREFIRE_XML="target/surefire-reports/TEST-*.xml"

mkdir -p "$REPORTS_DIR"

echo "🔍 Analyzing test results..."

# ============================================================================
# FUNCTION: Extract data from Cucumber JSON
# ============================================================================
extract_cucumber_stats() {
    if [[ ! -f "$CUCUMBER_JSON" ]]; then
        echo "0|0|0|0"
        return
    fi
    
    local total_scenarios=$(grep -o '"type": "scenario"' "$CUCUMBER_JSON" | wc -l || echo "0")
    local passed=$(grep -o '"result": {[^}]*"status": "passed"' "$CUCUMBER_JSON" | wc -l || echo "0")
    local failed=$(grep -o '"result": {[^}]*"status": "failed"' "$CUCUMBER_JSON" | wc -l || echo "0")
    local pending=$(grep -o '"result": {[^}]*"status": "pending"' "$CUCUMBER_JSON" | wc -l || echo "0")
    
    echo "$total_scenarios|$passed|$failed|$pending"
}

# ============================================================================
# FUNCTION: Extract data from Surefire XML
# ============================================================================
extract_surefire_stats() {
    local xml_file=$(ls $SUREFIRE_XML 2>/dev/null | head -1)
    
    if [[ ! -f "$xml_file" ]]; then
        echo "0|0|0|0"
        return
    fi
    
    local total=$(grep -oP 'tests="\K[^"]+' "$xml_file" | head -1 || echo "0")
    local failures=$(grep -oP 'failures="\K[^"]+' "$xml_file" | head -1 || echo "0")
    local skipped=$(grep -oP 'skipped="\K[^"]+' "$xml_file" | head -1 || echo "0")
    local passed=$((total - failures - skipped))
    
    echo "$total|$passed|$failures|$skipped"
}

# Get statistics
CUCUMBER_STATS=$(extract_cucumber_stats)
SUREFIRE_STATS=$(extract_surefire_stats)

IFS='|' read -r cuc_total cuc_passed cuc_failed cuc_pending <<< "$CUCUMBER_STATS"
IFS='|' read -r sure_total sure_passed sure_failures sure_skipped <<< "$SUREFIRE_STATS"

# General information
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A")
COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "N/A")

echo "✓ Cucumber: $cuc_passed/$cuc_total scenarios"
echo "✓ Surefire: $sure_passed/$sure_total tests"

# Calculate total and success percentage
TOTAL_TESTS=$((cuc_total + sure_total))
TOTAL_PASSED=$((cuc_passed + sure_passed))
SUCCESS_PERCENT=0
if [[ $TOTAL_TESTS -gt 0 ]]; then
    SUCCESS_PERCENT=$((TOTAL_PASSED * 100 / TOTAL_TESTS))
fi

# Create HTML
cat > "$REPORTS_DIR/index.html" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Report - CallForPaper App</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        header h1 { font-size: 2.5em; margin-bottom: 10px; }
        header p { font-size: 1.1em; opacity: 0.9; }
        .content { padding: 40px; }
        .summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        .card {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .card-title { font-size: 0.85em; color: #666; text-transform: uppercase; font-weight: bold; margin-bottom: 10px; }
        .card-value { font-size: 1.8em; font-weight: bold; color: #333; }
        .card.success { border-left-color: #28a745; }
        .card.success .card-value { color: #28a745; }
        .card.failed { border-left-color: #dc3545; }
        .card.failed .card-value { color: #dc3545; }
        .card.pending { border-left-color: #ffc107; }
        .card.pending .card-value { color: #ffc107; }
        .section { margin-bottom: 30px; }
        .section h2 { font-size: 1.3em; margin-bottom: 15px; color: #333; border-bottom: 2px solid #667eea; padding-bottom: 10px; }
        .report-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .report-link {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s;
            border: 2px solid transparent;
        }
        .report-link:hover {
            transform: translateY(-5px);
            border-color: #667eea;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .report-link-icon { font-size: 2em; margin-bottom: 10px; }
        .report-link h3 { margin-bottom: 5px; }
        .report-link p { font-size: 0.85em; color: #666; }
        footer {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #666;
            border-top: 1px solid #e9ecef;
            font-size: 0.9em;
        }
        .info { background: #e7f3ff; border-left: 4px solid #2196F3; padding: 15px; margin: 15px 0; border-radius: 5px; }
        .badge { display: inline-block; padding: 4px 8px; border-radius: 12px; font-size: 0.85em; font-weight: bold; }
        .badge-success { background: #d4edda; color: #155724; }
        .badge-danger { background: #f8d7da; color: #721c24; }
        .badge-warning { background: #fff3cd; color: #856404; }
        .stat-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .stat-box { background: #f8f9fa; padding: 20px; border-radius: 8px; border-left: 4px solid #667eea; }
        .stat-box h3 { margin-bottom: 15px; font-size: 1.1em; }
        .stat-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #e9ecef; }
        .stat-row:last-child { border-bottom: none; }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>☕ Test Report</h1>
            <p>CallForPaper App - Quality Dashboard</p>
        </header>
        
        <div class="content">
            <div class="summary">
                <div class="card">
                    <div class="card-title">📊 Total Tests</div>
                    <div class="card-value">TOTAL_TESTS</div>
                </div>
                <div class="card success">
                    <div class="card-title">✓ Passed</div>
                    <div class="card-value">TOTAL_PASSED</div>
                </div>
                <div class="card pending">
                    <div class="card-title">⏳ Pending</div>
                    <div class="card-value">TOTAL_PENDING</div>
                </div>
                <div class="card failed">
                    <div class="card-title">✗ Failed</div>
                    <div class="card-value">TOTAL_FAILED</div>
                </div>
            </div>
            
            <div class="info">
                <strong>ℹ️ Last Update:</strong> TIMESTAMP<br>
                <strong>Branch:</strong> BRANCH | <strong>Commit:</strong> COMMIT
            </div>
            
            <div class="section">
                <h2>🌐 Available Reports</h2>
                <div class="report-grid">
                    <a href="cucumber-html-reports/overview-features.html" class="report-link" target="_blank">
                        <div class="report-link-icon">🎯</div>
                        <h3>Features</h3>
                        <p>BDD Analysis</p>
                    </a>
                    <a href="cucumber-html-reports/overview-steps.html" class="report-link" target="_blank">
                        <div class="report-link-icon">📝</div>
                        <h3>Steps</h3>
                        <p>Statistics</p>
                    </a>
                    <a href="cucumber-html-reports/overview-failures.html" class="report-link" target="_blank">
                        <div class="report-link-icon">❌</div>
                        <h3>Failures</h3>
                        <p>Failed Scenarios</p>
                    </a>
                    <a href="cucumber-html-reports/overview-tags.html" class="report-link" target="_blank">
                        <div class="report-link-icon">🏷️</div>
                        <h3>Tags</h3>
                        <p>Grouping</p>
                    </a>
                </div>
            </div>
            
            <div class="section">
                <h2>📈 Statistics</h2>
                <div class="stat-grid">
                    <div class="stat-box">
                        <h3>🧪 Unit Tests (JUnit)</h3>
                        <div class="stat-row">
                            <span>Total</span>
                            <span><strong>SUREFIRE_TOTAL</strong></span>
                        </div>
                        <div class="stat-row">
                            <span>✓ Passed</span>
                            <span><strong class="badge badge-success">SUREFIRE_PASSED</strong></span>
                        </div>
                        <div class="stat-row">
                            <span>✗ Failed</span>
                            <span><strong>SUREFIRE_FAILED</strong></span>
                        </div>
                        <div class="stat-row">
                            <span>⏳ Skipped</span>
                            <span><strong>SUREFIRE_SKIPPED</strong></span>
                        </div>
                    </div>
                    
                    <div class="stat-box">
                        <h3>🥒 BDD Tests (Cucumber)</h3>
                        <div class="stat-row">
                            <span>Total Scenarios</span>
                            <span><strong>CUCUMBER_TOTAL</strong></span>
                        </div>
                        <div class="stat-row">
                            <span>✓ Passed</span>
                            <span><strong class="badge badge-success">CUCUMBER_PASSED</strong></span>
                        </div>
                        <div class="stat-row">
                            <span>✗ Failed</span>
                            <span><strong>CUCUMBER_FAILED</strong></span>
                        </div>
                        <div class="stat-row">
                            <span>⏳ Pending</span>
                            <span><strong class="badge badge-warning">CUCUMBER_PENDING</strong></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <footer>
            <p>🔄 Report generated automatically</p>
            <p>To regenerate: <code>mvn test verify</code></p>
        </footer>
    </div>
</body>
</html>
HTMLEOF

# Replace placeholders
sed -i "s|TOTAL_TESTS|$((sure_total + cuc_total))|g" "$REPORTS_DIR/index.html"
sed -i "s|TOTAL_PASSED|$((sure_passed + cuc_passed))|g" "$REPORTS_DIR/index.html"
sed -i "s|TOTAL_PENDING|$cuc_pending|g" "$REPORTS_DIR/index.html"
sed -i "s|TOTAL_FAILED|$((sure_failures + cuc_failed))|g" "$REPORTS_DIR/index.html"
sed -i "s|TIMESTAMP|$TIMESTAMP|g" "$REPORTS_DIR/index.html"
sed -i "s|BRANCH|$BRANCH|g" "$REPORTS_DIR/index.html"
sed -i "s|COMMIT|$COMMIT|g" "$REPORTS_DIR/index.html"

sed -i "s|SUREFIRE_TOTAL|$sure_total|g" "$REPORTS_DIR/index.html"
sed -i "s|SUREFIRE_PASSED|$sure_passed|g" "$REPORTS_DIR/index.html"
sed -i "s|SUREFIRE_FAILED|$sure_failures|g" "$REPORTS_DIR/index.html"
sed -i "s|SUREFIRE_SKIPPED|$sure_skipped|g" "$REPORTS_DIR/index.html"

sed -i "s|CUCUMBER_TOTAL|$cuc_total|g" "$REPORTS_DIR/index.html"
sed -i "s|CUCUMBER_PASSED|$cuc_passed|g" "$REPORTS_DIR/index.html"
sed -i "s|CUCUMBER_FAILED|$cuc_failed|g" "$REPORTS_DIR/index.html"
sed -i "s|CUCUMBER_PENDING|$cuc_pending|g" "$REPORTS_DIR/index.html"

echo ""
echo "✅ HTML Report generated: $REPORTS_DIR/index.html"
echo ""
echo "🌐 Open in your browser:"
echo "   file://$(pwd)/$REPORTS_DIR/index.html"
echo ""

# Generate Markdown report
echo "📄 Generating Markdown report..."
./scripts/create-markdown-report.sh
