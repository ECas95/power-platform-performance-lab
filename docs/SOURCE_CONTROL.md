# Canvas App Source Control Notes

Canvas App source is represented with `.pa.yaml` files in current supported source-control workflows.

Typical source includes `App.pa.yaml`, one `.pa.yaml` file per screen, and component source files.

## Repository policy

This lab does not hand-author a complete Canvas App source tree and claim it is importable without validation.

Instead:

1. Build or update the app through supported Power Platform tooling.
2. Publish the app.
3. Use Power Platform Git integration or supported CLI workflows to obtain source.
4. Commit the resulting source.
5. Review diffs.
6. Validate the app again in Power Apps Studio.

## Why this matters

The Canvas source schema continues to evolve. Large manual edits, generated YAML, or retired formats can produce misleading samples or invalid applications.

The benchmark harness is therefore initially published as Power Fx snippets and reproducible setup instructions. A validated source tree can be added after it has been round-tripped through an actual Power Platform environment.
