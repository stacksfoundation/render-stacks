if [ ! -z "${BNS_IMPORT_DIR}" ]; then
    echo "DEFINED \$BNS_IMPORT_DIR"
    if [ ! -f "${BNS_IMPORT_DIR}/imported" ]; then
        echo "NOTFOUND ${BNS_IMPORT_DIR}/imported"
    else
        echo "FOUND ${BNS_IMPORT_DIR}/imported"
    fi
else
    echo "NOT DEFINED \$BNS_IMPORT_DIR"
fi

