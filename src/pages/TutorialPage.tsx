import { TUTORIAL_TEXT } from "../data/targets";

export function TutorialPage() {
  return (
    <>
      <h1 className="settings-section-title">使用教程</h1>

      <div className="settings-card-block">
        <div className="settings-card-heading-row">
          <div>
            <h2 className="settings-card-heading">激活方式</h2>
            <p className="settings-card-description">
              注入后输入激活词即可生效；上下文被压缩后重新激活一次。
            </p>
          </div>
          <span className="badge badge-neutral">激活词「寒霜」</span>
        </div>

        <div className="panel-card" style={{ padding: "16px 18px" }}>
          <div className="app-prose">{TUTORIAL_TEXT}</div>
        </div>
      </div>
    </>
  );
}
