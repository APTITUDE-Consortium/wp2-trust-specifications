---
hide:
  - navigation
  - toc
---

<style>
  .md-content > h1,
  .md-content article > h1 {
    display: none !important;
  }
</style>

<div id="swagger-ui"></div>

<link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5/swagger-ui.css" />
<script src="https://unpkg.com/swagger-ui-dist@5/swagger-ui-bundle.js"></script>

<script>
  window.onload = () => {
    SwaggerUIBundle({
      url: '../../includes/register-oas3-api-read.yaml',
      dom_id: '#swagger-ui',
      presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
      ],
      layout: "BaseLayout"
    });
  };
</script>
