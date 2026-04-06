echo "shlib::list_functions (first 10):"
shlib::list_functions | head -10
echo "... ($(shlib::list_functions | wc -l | tr -d ' ') total functions)"
