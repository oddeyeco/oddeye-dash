<script src="${cp}/resources/select2/dist/js/select2.full.min.js"></script>

<script>
      $(document).ready(function() {
        $(".select2_country").select2({
          placeholder: "Select a Country",
          allowClear: true
        });
        $(".select2_tz").select2({});

      });
    </script>